class SessionsController < ApplicationController
  def new
    # Sign in form
  end

  def create
    puts "=== SIGN IN DEBUG ==="
    puts "Email: #{params[:email]}"
    puts "Password present: #{params[:password].present?}"
    
    user = User.find_by(email: params[:email].downcase)
    puts "User found: #{user.present?}"
    puts "User email: #{user&.email}"
    puts "Password check: #{user&.authenticate(params[:password])}" if user
    
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      puts "Sign in successful!"
      redirect_to root_path, notice: "Welcome back! 👋"
    else
      puts "Sign in failed!"
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You've been signed out! 👋"
  end
end
