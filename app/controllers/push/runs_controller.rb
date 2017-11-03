class Push::RunsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def show
    render json: Run.find(params[:id]), root: false, serializer: DeepRunSerializer
  end

  def index
    @job = Job.find params[:job_id]
    render json: @job.runs.to_json(only: [:id, :number]), root: false
  end
end