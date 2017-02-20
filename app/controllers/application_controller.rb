class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "adea" && password == "nancy"
      end
    end

    before_filter :authenticate
end
