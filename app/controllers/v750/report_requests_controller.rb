class V750::ReportRequestsController < V730::ReportRequestsController

  def respond
    @report_request = process_report_request

    push
    @report_request.alert! if @report_request.succeeded? || @report_request.failed?

    render json: @report_request, root: false
  end

  def status
    @report_request = ReportRequest.find(params[:report_request_id])

    push if @report_request.present?

    render json: @report_request, root: false
  end

  def report_data
    data = {}
    job = Job.find params[:job]
    if job.present?
      btr = BtrReceiverUpdate.active.last_update_for_job(job.name)
      logger = LoggerUpdate.active.last_update_for_job(job.name)
      data["job_id"] = job.id
      if logger.present?
        data["measured_depth"] = logger.bit_depth
        data["end_depth"] = logger.bit_depth
      end
      if btr.present?
        data["azm"] = btr.azm
        data["inc"] = btr.inc
        data["run"] = btr.run_number
      end
      data["start_depth"] = 0
    end

    render json: data, root: false
  end

  private

  def push
    if job
      data = {updated_at: DateTime.now.utc.to_s}.merge params
      Pusher["regen-script-#{@job.name.downcase}"].trigger("update", data)
    end
  end

end
