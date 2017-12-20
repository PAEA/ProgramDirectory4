require 'cgi'

module AuthenticateMe
  def new
  end

  def authenticate

    url = 'https://access.adea.org/paeadev/CENSSAWEBSVCLIB.AUTHENTICATION'
    login = params['login'].to_s.strip
    passw = CGI.escape(params['password'].to_s)
    data = 'p_input_xml_doc=<?xml version="1.0" encoding="UTF-8" ?><authentication-request><integratorUsername>paeadev</integratorUsername><integratorPassword>Authnt1c8n</integratorPassword><cust-id></cust-id><last-nm></last-nm><alias></alias><username>' + login + '</username><password><![CDATA[' + passw + ']]></password><session-id></session-id></authentication-request>'
    c = Curl::Easy.http_post(url, data) do |curl|
      curl.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    end
    xml_response = Nokogiri::XML(c.body_str)
    authentication = xml_response.search('authentication').map do |user|
      #puts user.inspect
      #puts user.at('company-name').text
      if user.at('authenticated').text == "true"
        session[:school] = user.at('company-name').text.gsub(" ","-")
        session[:display_username] = user.at('first-name').text + " " + user.at('last-name').text

        if user.at('roles').text.downcase.include?("og_editor01")
          # Regular user with read-only access
          session[:user_roles] = "editor01"
        elsif user.at('roles').text.downcase.include?("og_company_admin")
          # School administrator - can edit school information for their school only
          session[:user_roles] = "admin"
        elsif user.at('roles').text.downcase.include?("og_read")
          # Editor - can edit school information for any school plus approve or reject changes made by School administrators
          session[:user_roles] = "read"
        else
          # No access
          redirect_to root_path
        end
        flash[:success] = "Welcome!"
        redirect_to '/index'
      else
        session[:display_username] = nil
        session[:user_roles] = nil
        flash[:danger] = "Wrong username or password"
        redirect_to root_path
      end
    end

  end

  def destroy
    session[:display_username] = nil
    session[:user_roles] = nil
    flash[:success] = "Goodbye!"
    redirect_to root_path
  end

end
