class OrderTrackingChannel < ApplicationCable::Channel
  def subscribed
    order = Order.find_by(code: params[:code])

    if order
      stream_for order
    else
      reject
    end
  end
end
