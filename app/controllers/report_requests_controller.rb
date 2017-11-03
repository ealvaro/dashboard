class ReportRequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    @report_request = ReportRequest.new
    setup_report_request_types

    if params[:survey_id]
      survey = Survey.find(params[:survey_id])
      @from_survey = setup_survey_params(survey)
    elsif params[:job_id]
      survey = Survey.latest_by_job_id(params[:job_id]).first
      @from_survey = setup_survey_params(survey)
      unless @from_survey
        @report_request.job_id = params[:job_id]
      end
    end

  end

  def create
    @report_request = ReportRequest.new params.require(:report_request).permit(report_request_params).merge(requested_by_id: current_user.id)

    if params[:report_request].try(:[], :report_request_type_ids)
      params[:report_request][:report_request_type_ids].each do |id|
        report_request_type = ReportRequestType.find(id) unless id.empty?
        @report_request.report_request_types << report_request_type if report_request_type.present?
      end
    end

    if @report_request.validate_choice && @report_request.save
      if @report_request.request_correction
        @survey.alert!
      end

      @report_request.clear_from_choices

      redirect_to report_requests_path,
                  notice: "Reports requested for #{@report_request.job.name}"
    else
      setup_report_request_types

      render :new
    end
  end

  def show
    @report_request = ReportRequest.find(params[:id])
    setup_report_request_types
  end

  def index
    @active = ReportRequest.active
  end

  def recently_completed
    @recently_completed = ReportRequest.recent
  end

  def all
    @report_requests = ReportRequest.all.order(updated_at: :desc)
  end

  protected

  def report_request_params
    %i(id
       measured_depth
       inc
       azm
       job_id
       succeeded_at
       failed_at
       run_id
       description
       start_depth
       end_depth
       requested_by_id
       request_correction
       las_export
       request_survey
       request_reports
       )
  end

  def setup_report_request_types
    @headers = ReportRequestType.all.order('name asc').map(&:name).uniq

    @scales = {}
    ReportRequestType.all.order('scaling asc').map(&:scaling).uniq.each do |s|
      @scales[s] = ReportRequestType.where(scaling: s).order('name asc')
    end
  end

  def setup_survey_params(survey)
    if survey.present?
      @report_request.job_id = survey.job.try(:id)
      @report_request.measured_depth = survey.measured_depth
      @report_request.start_depth = survey.start_depth
      @report_request.end_depth = survey.measured_depth
      @report_request.azm = survey.azimuth
      @report_request.inc = survey.inclination
      @run = Run.find(survey.run.try(:id))
    end
    survey.present?
  end
end
