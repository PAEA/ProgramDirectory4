module AuthenticateMe
  def new
  end

  def authenticate

    url = 'https://access.adea.org/paeadev/CENSSAWEBSVCLIB.AUTHENTICATION'
    login = params['login'].to_s.strip
    passw = params['password'].to_s
    data = 'p_input_xml_doc=<?xml version="1.0" encoding="UTF-8" ?><authentication-request><integratorUsername>paea</integratorUsername><integratorPassword>Authnt1c8n</integratorPassword><cust-id></cust-id><last-nm></last-nm><alias></alias><username>' + login + '</username><password><![CDATA[' + passw + ']]></password><session-id></session-id></authentication-request>'
    c = Curl::Easy.http_post(url, data)
    xml_response = Nokogiri::XML(c.body_str)
    authentication = xml_response.search('authentication').map do |user|
      if ( user.at('authenticated').text == "true" && user.at('roles').text.downcase.include?("og_read") )
        session[:display_username] = user.at('display-name').text
        session[:user_roles] = user.at('roles').text
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
