require 'nokogiri'
require 'curb'

if ( File.file?("lib/special_access.rb") )
  load 'lib/special_access.rb'
  puts "special_access.file?:" + File.file?("lib/special_access.rb").to_s
else
  load 'lib/regular_access.rb'
  puts "regular_access.file?:" + File.file?("lib/regular_access.rb").to_s
end

class UserSessionsController < ApplicationController

  include AuthenticateMe

  #private

  #def user_session_params
  #  params.require(:user_session).permit(:login, :password, :user_terms)
  #end

end
