class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?

  def authenticate_user!
    if session[:user_id] && current_user
    else
      session[:return_to] = request.path
      redirect_to new_session_path, warning: "Please sign in to carry on"
    end
  end
  hide_action :authenticate_user!

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    @current_user
  end

  def blow_up
    raise "The entire system just blew up! Run and hide!"
  end

  def clean_db
    Client.destroy_all &&
    Job.destroy_all &&
    Run.destroy_all &&
    RunRecord.destroy_all &&
    Import.destroy_all &&
    ImportUpdate.destroy_all &&
    Well.destroy_all &&
    Formation.destroy_all &&
    Invoice.destroy_all &&
    Damage.destroy_all &&
    ToolType.where(number: nil).destroy_all
    redirect_to root_path
  end
end
