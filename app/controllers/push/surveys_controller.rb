class Push::SurveysController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def create
    run = Run.find(params[:run_id])
    runs = []
    ActiveRecord::Base.transaction do
      import_run = SurveyImportRun.create
      Array(params[:surveys]).each do |survey_params|
        @side_track = SideTrack.find_or_create_by(run: run, number: survey_params["side_track"]) unless survey_params["side_track"]
        @survey = Survey.import_for_run(side_track: @side_track, run: run, data: survey_params, user: nil, import_run: import_run)
        runs << @survey
        @survey.alert!
      end
    end
    render json: runs
  end

  def batch
    surveys = []
    ActiveRecord::Base.transaction do
      params[:runs].each do |param_run|
        run = Run.find(param_run[:run_id])
        import_run = SurveyImportRun.create
        Array(param_run[:surveys]).each do |survey_params|
          @side_track = SideTrack.find_or_create_by(run: run, number: survey_params["side_track"]) unless survey_params["side_track"]
          @survey = Survey.import_for_run(side_track: @side_track, run: run, data: survey_params, user: nil, import_run: import_run)
          surveys << @survey
          @survey.alert!
        end
      end
    end
    render json: surveys
  end
end
