module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :restaurant_user

    def connect
      self.restaurant_user = find_restaurant_user
    end

    private

    def find_restaurant_user
      env["warden"]&.user(:restaurant_user)
    end
  end
end
