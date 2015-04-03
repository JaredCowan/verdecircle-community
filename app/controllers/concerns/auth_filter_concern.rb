module AuthFilterConcern
  extend ActiveSupport::Concern

  included do
    :check_authorization ? skip_authorization_check : load_and_authorize_resource
  end

  private

    def check_authorization
      user_logged_in = current_user.nil?
      action = params[:action]

      if user_logged_in && action == ("profile" || "index" || "show")
        return true
      else
        return false
      end
    end
end
