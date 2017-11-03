class DrillerSessionsController < ApplicationController
  def new
  end

  def create
    user = User.where("lower(email) = ?", params[:email].downcase ).take.try(:authenticate, params[:password])
    if user
      job = Job.fuzzy_find(params[:job_number])
      if job
        run = Run.fuzzy_find(job, params[:run_number]) if job && params[:run_number]
        if run
          session[:user_id] = user.id
          session[:job_id] = job.id
          session[:run_id] = run.id
          redirect_to redirect_location, :notice => "Welcome back, #{user.email}"
        else
          flash.now.alert = "Please enter a valid run number"
          render "new"
        end
      else
        flash.now.alert = "Please enter a valid job number"
        render "new"
      end
    else
      flash.now.alert = "Please enter valid email and password"
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
