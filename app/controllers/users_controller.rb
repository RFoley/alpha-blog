class UsersController < ApplicationController
  before_action :set_user, only: %i[edit show update]
  before_action :require_same_user, only: %i[destroy edit update]
  before_action :require_admin, only: %i[:destroy]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Alpha Blog #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    flash[:danger] = 'User and all their articles have been deleted'
    redirect_to users_path
  end

  def edit
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Account details updated successfully'
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  private

  def require_admin
    unless logged_in? && current_user.admin?
      flash[:danger] = 'Access denied: You are not permitted to delete users'
      redirect_to root_path
    end
  end

  def require_same_user
    unless current_user == @user || current_user.admin?
      flash[:danger] = 'Access denied: You can only edit your own details'
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end