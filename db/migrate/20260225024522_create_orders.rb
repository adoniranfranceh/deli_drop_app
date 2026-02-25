class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :code, null: false
      t.integer :status, null: false, default: 0
      t.references :restaurant, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true

      # Delivery address snapshot
      t.string :delivery_address, null: false
      t.string :delivery_complement
      t.string :delivery_neighborhood
      t.string :delivery_reference

      # Values in cents
      t.integer :subtotal, null: false
      t.integer :delivery_fee, null: false, default: 0
      t.integer :discount, null: false, default: 0
      t.integer :total, null: false

      # Payment
      t.integer :payment_method, null: false
      t.integer :change_for
      t.integer :payment_status, null: false, default: 0

      # Notes and reasons
      t.text :customer_note
      t.text :rejection_reason
      t.text :cancellation_reason

      # Estimated delivery time in minutes
      t.integer :estimated_delivery_time

      # Pending timeout
      t.datetime :expires_at

      # Status timestamps
      t.datetime :confirmed_at
      t.datetime :preparing_at
      t.datetime :ready_at
      t.datetime :out_for_delivery_at
      t.datetime :delivered_at
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :orders, :code, unique: true
    add_index :orders, [:restaurant_id, :status]
    add_index :orders, :created_at
  end
end
