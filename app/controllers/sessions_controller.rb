class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.where("lower(email) = ?", params[:email].downcase ).take.try(:authenticate, params[:password])
    if user 
      session[:user_id] = user.id
      redirect_to redirect_location, :notice => "Welcome back, #{user.email}"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def redirect_location
    session[:return_to] || root_path
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end
end

