class Push::JobsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def show
    render json: Job.find(params[:id]), root: false
  end

  def invoices
    @job = Job.find(params[:job_id])
    render json: @job.invoices, root: false
  end

  def index
    jobs = Job.all.order(:name).page(params[:page])
    render json: jobs, meta: { pages: jobs.total_pages }, each_serializer: ActiveJobSerializer
  end

  def search
    @job = Job.fuzzy_find(params[:job_number])
    render json: @job || {}, root: false
  end

  def active
    job = Job.find(params[:id])
    @job = ActiveJobSerializer.new(job, root: false).to_json
    render json: @job
  end

  def create
    job = Job.new(job_params)
    if job.save
      render json: { message: "Success" }, status: 200
    else
      render json: { message: "Fail" }, status: 422
    end
  end

  def update
    job = Job.find(params[:id])
    if job.update(job_params)
      render json: { message: "Success" }, status: 200
    else
      render json: { message: "Fail" }, status: 422
    end
  end

  def destroy
    job = Job.find(params[:id])
    if job.destroy
      render json: { message: "Success" }, status: 200
    else
      render json: { message: "Fail" }, status: 422
    end
  end

  def search_all
    keywords = params[:keywords]
    jobs = Job.search(keywords).page(params[:page])
    render json: jobs, meta: { pages: jobs.total_pages }, each_serializer: ActiveJobSerializer
  end

  def recent_updates
    job = Job.find params[:id]
    updates = job.recent_updates_for_type(params[:type])
    render json: updates, root: false
  end

  def mark_inactive
    mark_inactivity true
  end

  def mark_active
    mark_inactivity false
  end

  private

    def mark_inactivity activity
      job = find_job
      job.inactive = activity
      if_save job
    end

    def if_save job
      if job.save
        job.touch
        render json: ActiveJobSerializer.new(job, root: false)
      else
        render json: { message: job.errors }, status: 422
      end
    end

    def find_job
      Job.find params[:id]
    end

    def job_params
      params.require(:job).permit(:name, :client_id)
    end
end