class UsersController < ApplicationController

  before_action :require_login, only: [:show]
  before_action :authorize_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome! 🎉"
    else
      flash.now[:alert] = "There was a problem creating your account."
      render :new
    end
  end

  def show
    # @user is already set by authorize_user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def require_login
    unless current_user
      redirect_to sign_in_path, alert: "Please sign in to access this page."
    end
  end

  def authorize_user
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to root_path, alert: "You are not authorized to view that page."
    end
  end
end
