module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_chef_id

    def connect
      self.current_chef_id = find_verified_chef_id
    end

    private

    def find_verified_chef_id
      chef_id = request.session[:chef_id] || cookies.signed[:chef_id]
      if chef_id.present?
        chef_id
      else
        reject_unauthorized_connection
      end
    end
  end
end
