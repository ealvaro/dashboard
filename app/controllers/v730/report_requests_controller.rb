class V730::ReportRequestsController < V710::ReportRequestsController

  def index
    @job = job
    if @job
      if params[:all]
        render json: @job.report_requests
      else
        render json: @job.report_requests.active
      end
    else
      render json: { error: "You must include a job number or a job_id" },
             status: :bad_request
    end
  end

  private

  def default_serializer_options
    {each_serializer: V730::ReportRequestSerializer, root: false}
  end

end
