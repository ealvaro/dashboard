class FormationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @formation = Formation.new
  end

  def index
    @formations = Formation.all.order(name: :asc).page params[:page]
  end

  def show
    @formation = Formation.find(params[:id])
  end

  def edit
    @formation = Formation.find(params[:id])
  end

  def create
    @formation = Formation.create formation_params
    if @formation.valid?
      return redirect_to formations_path, notice: "Formation created"
    else
      render :new
    end
  end

  def update
    @formation = Formation.find(params[:id])
    @formation.update_attributes formation_params
    if @formation.valid?
      return redirect_to formations_path, notice: "Formation updated"
    else
      render :edit
    end
  end

  def search
    keywords = params[:keywords]
    @formations = Formation.search(keywords).page params[:page]
    render :index
  end

  private

  def formation_params
    params.require(:formation).permit(:name, :multiplier)
  end

end
