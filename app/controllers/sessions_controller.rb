class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = 'Login successful'
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'Login failed: Username or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Logout successful'
    redirect_to root_path
  end

end