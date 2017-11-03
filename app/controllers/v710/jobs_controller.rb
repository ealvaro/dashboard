class V710::JobsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def receiver_updates
    if /^[a-zA-Z]{2}-[0-9]{6}$/.match(params[:job].try(:to_s))
      receiver_type = params[:receiver_type] ? params[:receiver_type] : "leam-receiver"

      if ["leam-receiver", "btr-receiver", "logger", "em-receiver"].include?(receiver_type)
        job_number = params[:job].downcase

        if @job = Job.fuzzy_find(job_number)
          Pusher["active-jobs"].trigger("update", {message: "Please refresh your jobs!"}) unless Job.active.include? @job
          @job.touch

          data = {updated_at: DateTime.now.utc.to_s, receiver_type: receiver_type, job: job_number}.merge params

          Pusher["active-job-data"].trigger("update", data)
          Pusher["#{receiver_type.downcase}-#{job_number.downcase}"].trigger("update", data)
          Pusher["#{receiver_type.downcase}-#{job_number.downcase}"].trigger("pulse", data)

          render json: {message: "Successfully updated receiver."}
        else
          render json: {message: "The job '#{job_number}' does not exist."},
                 status: 400
        end
      else
        render json: {message: "Please supply a valid receiver type."},
               status: 400
      end
    else
      render json: {message: "Please supply a valid job number."}, status: 400
    end
  end

  def logger_updates
    if /^[a-zA-Z]{2}-[0-9]{6}$/.match(params[:job].try(:to_s))
      job_number = params[:job].downcase

      if @job = Job.fuzzy_find(job_number)
        Pusher["active-jobs"].trigger("update", {message: "Please refresh your jobs!"}) unless Job.active.include? @job
        @job.touch
      end

      data = {updated_at: DateTime.now.utc.to_s, receiver_type: "logger", job: job_number}.merge params

      Pusher["logger-#{job_number.downcase}"].trigger("update", data)
      Pusher["active-job-data"].trigger("update", data)

      render json: {message: "Successfully updated receiver."}
    else
      render json: {message: "Please supply a valid job number."}, status: 400
    end
  end

  def active
    render json: Job.active, root: false, each_serializer: ActiveJobSerializer
  end

  def test_logger
    @job = Job.find(params[:id])
    TestLogger.new(@job).publish_notify
    render json: { message: "Logger test events sent" }
  end

  def test_receiver_btr
    @job = Job.find(params[:id])
    TestReceiver.new(@job).publish_notify(true)
    render json: { message: "BTR test events sent" }
  end

  def test_receiver_leam
    @job = Job.find(params[:id])
    TestReceiver.new(@job).publish_notify(false)
    render json: { message: "Leam receiver test events sent" }
  end
end
