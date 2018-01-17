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
        session[:school_display] = user.at('company-name').text
        session[:display_username] = user.at('first-name').text + " " + user.at('last-name').text

        check_role = true
        # Strings containing \n need to get split using double quotes
        this_user_roles = user.at('roles').text.split("\n")
        this_user_roles.each do |this_role|
          test = this_role.to_s
          if check_role && ( get_role = SettingsRole.find_by role: test )

            # Set role
            session[:user_role_id] = get_role.id
            session[:user_role] = get_role.role_type
            if session[:user_role]['admin'] || session[:user_role]['editor'] || session[:user_role]['read']
              flash[:success] = "Welcome!"
              check_role = false
              redirect_to '/index'
            end
          end
        end

      else
        session[:display_username] = nil
        session[:user_role] = nil
        flash[:danger] = "Wrong username or password"
        redirect_to root_path
      end
    end

  end

  def destroy
    session[:display_username] = nil
    session[:user_role] = nil
    flash[:success] = "Goodbye!"
    redirect_to root_path
  end

end
