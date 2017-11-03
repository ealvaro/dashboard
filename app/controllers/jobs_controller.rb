class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.all.order(:name).page(params[:page])
    @decorated_jobs = @jobs.decorate
    authorize_action_for Job
  end

  def show
    authorize_action_for @job
  end

  def new
    @job = Job.new( client: @client ).decorate
    authorize_action_for @job
  end

  def edit
    authorize_action_for @job
  end

  def create
    @job = Job.new(job_params).decorate
    authorize_action_for @job

    if @job.save
      redirect_to job_path( @job )
    else
      render :new
    end
  end

  def update
    authorize_action_for @job
    if @job.update(job_params)
      redirect_to job_path( @job ), notice: 'Job was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize_action_for @job
    @client = @job.object.client
    @job.destroy
    redirect_to client_jobs_path( @client ), notice: 'Job was successfully destroyed.'
  end

  def show_receiver
    @job = Job.find(params[:id])
    @job_json = ActiveJobSerializer.new(@job, root: false).to_json

    @notifiers = Notifier.visible

    updates = {}
    if logger_update = @job.last_update_for_type("LoggerUpdate")
      update = V744::LoggerUpdateSerializer.new(logger_update, root: false)
      updates["LoggerUpdate"] = update
    end

    ReceiverUpdate.descendants.map(&:to_s).each do |receiver|
      if receiver_update = @job.last_update_for_type(receiver)
        update = V744::ReceiverUpdateSerializer.new(receiver_update, root: false)
        updates[receiver] = update
      end
    end

    @updates_json = updates.to_json
  rescue ActiveRecord::RecordNotFound
    render text: "Job not found", status: 404
  end

  def show_receiver_settings
    @job = Job.find(params[:id])
    @receiver_settings = ReceiverSetting.by_job(@job).latest_versions
    @receiver_settings = @receiver_settings.sort_by(&:updated_at).reverse
    @types = { "BtrSetting"=>"BTR", "LrxSlaveSetting"=>"LRx Slave",
               "BtrSlaveSetting"=>"BTR Slave" }
  rescue ActiveRecord::RecordNotFound
    render text: "Job not found", status: 404
  end

  def search
    keywords = params[:keywords]
    @jobs = Job.search(keywords).page(params[:page])
    @decorated_jobs = @jobs.decorate
    render :index
  end

  private

  def set_job
    @job = Job.find(params[:id]).decorate
  end

  def job_params
    params.require(:job).permit(:customer_id, :id, :name, :client_id )
  end
end
