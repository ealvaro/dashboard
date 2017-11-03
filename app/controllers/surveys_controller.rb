require 'csv'
class SurveysController < ApplicationController
  before_action :authenticate_user!

  before_action do
    authorize_action_for Survey
  end

  before_action :set_job_and_runs

  def index
    @surveys = Survey.visible.order("created_at DESC").where(version_number: 1).page(params[:page])
  end

  def show
    @survey = Survey.where(key: params[:id]).order("version_number DESC").limit(1).first
    @job = @survey.job
    @runs = @job.runs
  end

  def new
    @survey = Survey.new.tap {|s| s.selected_depth_units = "feet"; s.magnetic_units = "NanoTesla"}
  end

  def job
    @surveys = @job.surveys.where(version_number: 1)
  end

  def ignore
    @survey = Survey.where(key: params[:id]).update_all(hidden: true)
    redirect_to surveys_path, notice: "Survey Ignored"
  end

  def export_job
    @surveys = @job.surveys.where(version_number: 1)
    @surveys.map{|s| s.versions.last }

    send_data(surveys_csv, :type => 'text/csv', :filename => 'survey_data.csv')
  end

  def clip
    @surveys = @job.surveys.where(version_number: 1)
    @surveys = @surveys.map{|s| s.versions.last }

    @form = SurveyClipForm.new.tap do |form|
      form.pasted_data = surveys_csv
    end
  end

  def apply_clip
    @surveys = @job.surveys.where(version_number: 1)
    @form = SurveyClipForm.new(params[:survey_clip_form])
    @form.job_id = params[:job_id]
    @form.user = current_user
    @form.apply_updates!
    redirect_to surveys_by_job_path(id: params[:job_id]), notice: "Updated"
  end

  def corrections
    @form = SurveyImportForm.new(col_sep: ",").tap do |form|
      [:order_md, :order_inc, :order_azi, :order_dipa, :order_gx, :order_gy, :order_gz, :order_hx, :order_hy, :order_hz].each_with_index do |a, i|
        form.send("#{a}=", i+1)
      end
    end
  end

  def apply_corrections
    @form = SurveyImportForm.new(params[:survey_import_form])
    @run = Run.find(@form.run_id)
    @side_track = SideTrack.find_or_create_by(run: @run, number: @form.side_track_number) unless @form.side_track_number.blank?
    @runs = @run.job.runs

    if params[:commit] =~ /apply/i
      import_run = SurveyImportRun.create!
      @form.data.each do |hash|
        Survey.import_for_run( side_track: @side_track, run: @run, data: hash, user: current_user, import_run: import_run)
      end
      redirect_to surveys_path, notice: "Imported"
    else
      render :corrections
    end
  end


  def apply
    original_survey = Survey.find_by key: params[:id], version_number: 1
    @survey = Survey.new params.require(:survey).permit(survey_params)
    @survey.side_track = SideTrack.find_or_create_by(run: @survey.run, number: params[:survey][:side_track_number]) if @survey.run && params[:survey][:side_track_number]
    @survey.key = original_survey.key
    @survey.user = current_user
    @survey.version_number += original_survey.versions.last.version_number
    if @survey.save
      redirect_to @survey, notice: "Change Applied"
    else
      render :show
    end
  end

  def create
    @survey = Survey.new params.require(:survey).permit(survey_params)
    if @survey.save
      if params[:commit] =~ /another/i
        redirect_to new_survey_path, notice: "Saved, Adding Another"
      else
        redirect_to surveys_path, notice: "Saved"
      end
    else
      render :new
    end
  end

  def delete_run
    SurveyImportRun.destroy params[:id]
    redirect_to survey_imports_path, notice: "Import removed"
  end

  def imports
    @survey_import_runs = SurveyImportRun.all.order("created_at desc")
  end

  def edit_approval
    @survey = Survey.find_by(key: params[:id]).versions.last
    @survey.accept = true
    @job = @survey.job
    @run = @survey.run
  end

  def update_approval
    @survey = Survey.find_by(key: params[:id]).versions.last

    @survey.assign_attributes approval_survey_params
    if @survey.accept == 'true'
      @survey.accepted_by = current_user
    else
      @survey.declined_by = current_user
    end

    @survey.save
    if @survey.valid?
      if @survey.accept == 'true'
        redirect_to new_report_request_path(survey_id: @survey.id),
                    notice: "Approval Choice Saved"
      else
        redirect_to surveys_path,
                    notice: "Approval Choice Saved"
      end
    else
      render :edit_approval
    end
  end

  def approval_survey_params
    params.require(:survey).permit(:measured_depth, :accept)
  end

  authority_actions :ignore=> 'update', :apply => 'update', corrections: 'update', apply_corrections: "update", job: "read", export_job: "read", clip: "read", imports: "read", delete_run: "update", apply_clip: "update", edit_approval: "read", update_approval: "update"

  private

  def surveys_csv
    CSV.generate do |csv|
      @surveys.each do |survey|
        csv << [survey.measured_depth_in_feet, survey.gx, survey.gy, survey.gz, survey.hx, survey.hy, survey.hz]
      end
    end
  end

  def set_job_and_runs
    @job = Job.find(params[:job_id]) if params[:job_id]
    @runs = @job.runs if @job
  end

  def survey_params
    %i(
      run_id
      measured_depth
      selected_depth_units
      gx
      gy
      gz
      g_total
      hx
      hy
      hz
      magnetic_units
      g_total
      inclination
      azimuth
      dip_angle
      north
      east
      tvd
      horizontal_section
      dog_leg_severity
      col_sep
      )
  end
end
