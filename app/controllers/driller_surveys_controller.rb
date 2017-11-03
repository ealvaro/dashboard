class DrillerSurveysController < ApplicationController
  before_action :authenticate_user!

  before_action do
    authorize_action_for DrillingDashboard
  end

  layout "drilling"

  def create
    params[:survey][:run_id] = session[:run_id] if session[:run_id]
    @survey = Survey.new params.require(:survey).permit(survey_params)

    max_depth = Survey.max_measured_depth(@survey.run_id)
    if max_depth.empty? or @survey.measured_depth.to_i > max_depth.first.measured_depth
      if @survey.save
        redirect_to driller_surveys_path, notice: "Added a future survey"
      else
        if @survey.errors[:measured_depth].any?
          redirect_to driller_surveys_path, notice: "Please enter a valid measured depth"
        else
          redirect_to driller_surveys_path
        end
      end
    else
      redirect_to driller_surveys_path, notice: "Measured depth must be greater than last entry"
    end
  end

  def index
    @survey = Survey.new
    @job = Job.find(session[:job_id]) if session[:job_id]
    @run = Run.find(session[:run_id]) if session[:run_id]

    @surveys = @run.surveys.where(version_number: 1)
               .order("measured_depth_in_feet ASC").order("created_at ASC")

    if @surveys.length < 3
      flash[:alert] = "Please add at least three surveys"
    end
  end

  authority_actions index: "read", create: "update"

  private

  def survey_params
    %i(
      run_id
      measured_depth
      selected_depth_units
      inclination
      azimuth
      north
      east
      tvd
      horizontal_section
      dog_leg_severity
      col_sep
      )
  end
end
