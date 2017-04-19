class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception

  #protected
  #  def authenticate
  #    authenticate_or_request_with_http_basic do |username, password|
  #      username == "adea" && password == "nancy"
  #    end
  #  end

  #  before_filter :authenticate
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  helper_method :current_user_session, :current_user

end
