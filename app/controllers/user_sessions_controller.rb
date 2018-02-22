require 'nokogiri'
require 'curb'
require 'bcrypt'

if ( File.file?("lib/special_access.rb") )
  load 'lib/special_access.rb'
else
  load 'lib/regular_access.rb'
end

class UserSessionsController < ApplicationController

  include AuthenticateMe

  def terms_and_conditions_pdf
    send_file "#{Rails.root}/public/files/ADEA Dental School Explorer Terms and Conditions 7-7-17.pdf", type: "application/pdf", x_sendfile: true
  end

  def maintenance
  end

  #private

  #def user_session_params
  #  params.require(:user_session).permit(:login, :password, :user_terms)
  #end

end
