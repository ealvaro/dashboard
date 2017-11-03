class Push::SubscriptionsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    @run = Run.find params[:run_id] if params[:run_id]
    @job = Job.find_by(name: params[:job][:name]) if params[:job] && params[:job][:name]
    @job ||= @run.try(:job)
    @subscription = Subscription.find_or_create_by user_id: params[:user_id], job_id: ( @job.try(:id) || params[:job_id] )
    render json: @subscription, root:false, serializer: ShallowSubscriptionSerializer
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy!
    render json: {}
  end
end
