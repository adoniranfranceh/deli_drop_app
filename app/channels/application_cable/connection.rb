module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :restaurant_user, :guest_id

    def connect
      self.restaurant_user = env["warden"]&.user(:restaurant_user)
      self.guest_id = SecureRandom.uuid unless restaurant_user
    end
  end
end
