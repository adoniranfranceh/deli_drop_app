class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_many :order_status_logs, dependent: :destroy

  accepts_nested_attributes_for :order_items

  enum :status, {
    pending: 0,
    confirmed: 5,
    preparing: 10,
    ready: 15,
    out_for_delivery: 20,
    delivered: 25,
    cancelled: 90,
    rejected: 95
  }

  enum :payment_method, { pix: 0, cash: 5 }
  enum :payment_status, { payment_pending: 0, payment_confirmed: 5 }, prefix: :payment

  validates :code, presence: true, uniqueness: true
  validates :status, :payment_method, :payment_status, presence: true
  validates :delivery_address, presence: true
  validates :subtotal, :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :delivery_fee, :discount, numericality: { greater_than_or_equal_to: 0 }
  validates :change_for, numericality: { greater_than: 0 }, allow_nil: true

  validate :restaurant_must_be_open, on: :create

  after_create_commit :broadcast_new_order
  after_update_commit :broadcast_order_update, if: :status_previously_changed?

  before_validation :generate_code, on: :create
  before_validation :set_expires_at, on: :create

  PENDING_TIMEOUT_MINUTES = 10

  STATUS_TRANSITIONS = {
    "pending"          => %w[confirmed rejected cancelled],
    "confirmed"        => %w[preparing cancelled],
    "preparing"        => %w[ready cancelled],
    "ready"            => %w[out_for_delivery],
    "out_for_delivery" => %w[delivered]
  }.freeze

  CUSTOMER_CANCELLABLE = %w[pending confirmed].freeze

  def can_transition_to?(new_status)
    STATUS_TRANSITIONS.fetch(status, []).include?(new_status.to_s)
  end

  def customer_can_cancel?
    CUSTOMER_CANCELLABLE.include?(status)
  end

  def transition_to!(new_status, changed_by:, note: nil)
    raise InvalidTransitionError unless can_transition_to?(new_status)

    old_status = status
    now = Time.current

    self.status = new_status
    assign_status_timestamp(new_status, now)

    save!

    order_status_logs.create!(
      from_status: self.class.statuses[old_status],
      to_status: self.class.statuses[new_status.to_s],
      changed_by: changed_by,
      note: note
    )
  end

  class InvalidTransitionError < StandardError
    def message
      "Transição de status inválida"
    end
  end

  private

  def generate_code
    return if code.present?

    loop do
      self.code = "DD-#{SecureRandom.alphanumeric(4).upcase}"
      break unless Order.exists?(code: code)
    end
  end

  def set_expires_at
    self.expires_at ||= Time.current + PENDING_TIMEOUT_MINUTES.minutes
  end

  def assign_status_timestamp(new_status, time)
    timestamp_map = {
      "confirmed"        => :confirmed_at,
      "preparing"        => :preparing_at,
      "ready"            => :ready_at,
      "out_for_delivery" => :out_for_delivery_at,
      "delivered"        => :delivered_at,
      "cancelled"        => :cancelled_at,
      "rejected"         => :cancelled_at
    }

    attr = timestamp_map[new_status.to_s]
    send(:"#{attr}=", time) if attr
  end

  def broadcast_new_order
    RestaurantOrdersChannel.broadcast_to(restaurant, {
      type: "new_order",
      order: restaurant_order_payload
    })
  end

  def broadcast_order_update
    OrderTrackingChannel.broadcast_to(self, {
      code: code,
      status: status,
      estimated_delivery_time: estimated_delivery_time,
      confirmed_at: confirmed_at,
      preparing_at: preparing_at,
      ready_at: ready_at,
      out_for_delivery_at: out_for_delivery_at,
      delivered_at: delivered_at,
      cancelled_at: cancelled_at,
      cancellation_reason: cancellation_reason,
      rejection_reason: rejection_reason
    })

    RestaurantOrdersChannel.broadcast_to(restaurant, {
      type: "order_updated",
      order: restaurant_order_payload
    })
  end

  def restaurant_order_payload
    {
      id: id,
      code: code,
      status: status,
      customer_name: customer.name,
      customer_phone: customer.phone,
      total: total,
      payment_method: payment_method,
      items_count: order_items.size,
      estimated_delivery_time: estimated_delivery_time,
      expires_at: expires_at,
      created_at: created_at
    }
  end

  def restaurant_must_be_open
    return if restaurant.nil?
    return if restaurant.open_now?

    errors.add(:base, "O restaurante está fechado no momento")
  end
end
