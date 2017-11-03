class RunsController < ApplicationController
  before_action :authenticate_user!
  before_action :prevent_datetime_field_overflow, only: [:create, :update]
  before_action :set_job
  before_action :set_well, only: [:index]
  before_action :set_run, only: [:show, :edit, :update, :destroy]
  before_action :set_wells, only: [:new, :create, :edit, :update]

  def index
    @runs = Run.joins(:job).order("jobs.name ASC, runs.number ASC").page params[:page]
    @decorated_runs = @runs.decorate
    authorize_action_for Run
  end

  def show
    authorize_action_for @run
    @events = @run.events.order(time: :desc).page params[:page]
  end

  def new
    @run = Run.new( well_id: params[:well_id], job_id: params[:job_id] )
    authorize_action_for @run
  end

  def edit
    authorize_action_for @run
  end

  def create
    @run = Run.new( run_params ).decorate
    authorize_action_for @run

    if @run.save
      redirect_to run_path( @run ), notice: 'Run was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize_action_for @run
    if @run.update(run_params)
      redirect_to run_path( @run ), notice: 'Run was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize_action_for @run
    @job = @run.object.job
    @run.destroy
    redirect_to job_runs_path( @job ), notice: 'Run was successfully destroyed.'
  end

  def search
    keywords = params[:keywords]
    jobs = Job.search keywords
    @runs = Run.search(jobs).page(params[:page])
    @decorated_runs = @runs.decorate
    render :index
  end

  private

  def set_job
    @job = Job.find( params[:job_id] ) if params[:job_id]
  end

  def set_well
    @well = Well.find( params[:well_id] ) if params[:well_id]
  end

  def set_run
    @run = Run.find(params[:id]).decorate
  end

  def run_params
    params.require(:run).permit(:job_id, :occurred, :well_id, :rig_id, :number)
  end

  def set_wells
    @wells = Well.all.collect{ |w| [w.name, w.id] }
  end

  def prevent_datetime_field_overflow
    params[:run][:occurred] = DateTime.now - 50.years if !params[:run].blank? && !params[:run][:occurred].blank? && params[:run][:occurred].to_datetime < DateTime.now - 50.years
  end
end
