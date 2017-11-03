module TokenAuthenticating
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :null_session
    before_action :authenticate_request
  end

  def authenticate_request
    if request.headers["X-Auth-Token"] != auth_token || auth_token.blank?
      render text: "unauthorized request", status: 401 and return false
    end
  end

  def auth_token
    ENV["auth_token"]
  end
end
