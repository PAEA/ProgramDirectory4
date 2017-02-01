class SchoolsController < ApplicationController

  def index
    @schools = School.all
  end

  def information
    @id = params[:id]
    @schools = School.find(@id)
  end

end
