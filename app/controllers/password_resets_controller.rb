class PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user.nil?
      flash[:error] = "No user found with that email address"
      render :new
    else
      user.generate_token(:password_reset_token)  
      user.password_reset_sent_at = Time.zone.now  
      user.save!
      UserMailer.password_reset(user).deliver  
      redirect_to root_url, :notice => "Email sent with password reset instructions."  
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update  
    @user = User.find_by_password_reset_token!(params[:id])  
    if @user.password_reset_sent_at < 2.hours.ago  
      redirect_to new_password_reset_path, :alert => "Password reset has expired."  
    else
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        redirect_to root_url, :notice => "Password has been reset."  
      else  
        render :edit  
      end
    end  
  end 

end