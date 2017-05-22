require 'nokogiri'

class UserSessionsController < ApplicationController
  def new
  #  @user_session = UserSession.new
  end

  def authenticate
    #@user_session = UserSession.new(user_session_params)
    #if @user_session.save
      url = 'https://access.adea.org/paeadev/CENSSAWEBSVCLIB.AUTHENTICATION'
      login = params['login'].to_s.strip
      passw = params['password'].to_s.strip
      c = Curl::Easy.http_post(url, 'p_input_xml_doc=<?xml version="1.0"?><authentication-request><integratorUsername>paea</integratorUsername><integratorPassword>Authnt1c8n</integratorPassword><cust-id></cust-id><last-nm></last-nm><alias></alias><username>' + login + '</username><password>' + passw + '</password><session-id></session-id></authentication-request>') do |curl|
        curl.headers['Content-Type'] = 'text/xml'
      end
      xml_response = Nokogiri::XML(c.body_str)
      authentication = xml_response.search('authentication').map do |user|
        if ( user.at('authenticated').text == "true" )
          $display_username = user.at('display-name').text
          $user_roles = user.at('roles').text
          flash[:success] = "Welcome!"
          redirect_to '/index'
        else
          $display_username = nil
          $user_roles = nil
          flash[:danger] = "Wrong username or password"
          redirect_to root_path
        end
      end

  end

  def destroy
    $display_username = nil
    $user_roles = nil
    flash[:success] = "Goodbye!"
    redirect_to root_path
  end

  #private

  #def user_session_params
  #  params.require(:user_session).permit(:login, :password, :remember_me)
  #end
end
