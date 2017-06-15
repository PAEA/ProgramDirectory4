module AuthenticateMe

  def new
    @user_session = UserSession.new
  end

  def authenticate

    @user = User.find_by_login(params[:login])
    if @user.password == params[:password]
      flash[:success] = "Wrong username or password"
    else
      flash[:success] = "Welcome back!"
      redirect_to "/index"
    end

  end

  def destroy
    current_user_session.destroy
    flash[:success] = "Goodbye!"
    redirect_to root_path
  end

end
