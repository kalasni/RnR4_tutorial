class UsersController < ApplicationController


  # Require users to be logged in before permit actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy] # Only admin can delete users

  def index
    # (30 by default)  page 1 is users 1–30, page 2 is users 31–60, etc
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])  # Technically, params[:id] is the string "1"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user  # Igual a redirect_to user_url(@user)  (show view)
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update

    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:succes] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user

     # from sessions_helper
      unless logged_in?
        store_location  # from sessions_helper
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # confirm the correct user
    def correct_user
      @user = User.find(params[:id])
      #redirect_to(root_path) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirm an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
