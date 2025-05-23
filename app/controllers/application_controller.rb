class ApplicationController < ActionController::Base

 skip_forgery_protection

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Please sign in to continue"
      redirect_to sign_in_path
    end
  end
  
end
