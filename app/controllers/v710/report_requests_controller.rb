class V710::ReportRequestsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    render json: ReportRequest.create(strong_params.merge(requested_by_id: current_user.id)), root: false
  end

  def index
    @job = job
    if @job
      if params[:all]
        render json: @job.report_requests, root: false
      else
        render json: @job.report_requests.active, root: false
      end
    else
      render json: { error: "You must include a job number or a job_id" }, status: 400
    end
  end

  def respond
    @report_request = process_report_request
    @report_request.alert!

    render json: @report_request, root: false
  end

  protected

  def process_report_request
    ActiveRecord::Base.transaction do
      @report_request = ReportRequest.find(params[:report_request_id])

      @report_request.update_attributes description: params[:description],
      run_id: params[:run_id],
      completed_by: params[:user_email],
      software_installation_id: params[:software_installation_id]

      @report_request.failed_at = DateTime.strptime(params[:failed_at].to_s, "%s") if params[:failed_at]
      @report_request.succeeded_at = DateTime.strptime(params[:succeeded_at].to_s, "%s") if params[:succeeded_at]
      @report_request.save

      if params[:assets]
        params[:assets].each do |key, value|
          ea = @report_request.report_request_assets.build
          ea["name"] = key
          ea["file"] = value
          break unless ea.save
        end
      end

      @report_request
    end
  end

  def job
    @job = Job.find(params[:job_id]) if params[:job_id]
    @job ||= Job.fuzzy_find(params[:job_number]) if params[:job_number]
    @job
  end

  def strong_params
    params.permit(
      :id, :measured_depth, :inc, :azm, :job_id, :succeeded_at, :failed_at, :run_id, :description, :start_depth
    )
  end
end
