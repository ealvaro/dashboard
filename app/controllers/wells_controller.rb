class WellsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_formations, except: [:index, :show]
  before_action :set_well, only: [:show, :edit, :update]

  def index
    @wells = Well.all.order(name: :asc).page params[:page]
    @decorated_wells = @wells.decorate
    authorize_action_for Well
  end

  def show
    authorize_action_for @well
  end

  def new
    @well = Well.new
    authorize_action_for @well
  end

  def edit
    authorize_action_for @well
  end

  def create
    @well = Well.new(well_params)
    authorize_action_for @well

    if @well.save
      redirect_to @well, notice: 'Well was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    authorize_action_for @well
    if @well.update(well_params) && @well.decorate
      redirect_to @well, notice: 'Well was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def search
    keywords = params[:keywords]
    @wells = Well.search(keywords).page params[:page]
    @decorated_wells = @wells.decorate
    render :index
  end

  private

  def set_well
    @well = Well.find(params[:id]).decorate
  end

  def well_params
    params.require(:well).permit(:name, :formation_id)
  end

  def set_formations
    @formations = Formation.all.collect{ |f| [f.name, f.id] } || []
  end
end
