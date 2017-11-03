class RigGroupsController < ApplicationController
  before_action :set_rig_group, only: [:show, :edit, :update, :destroy]

  # GET /rig_groups
  def index
    @rig_groups = RigGroup.all.order("name ASC")
    render json: @rig_groups, root: false, each_serializer: RigGroupSerializer
  end

  # GET /rig_groups/1/rigs
  def rigs
      render json: RigGroup.find(params[:id]).rigs, root: false
  end

  # GET /rig_groups/1/notifiers
  # do not use.  use /notifiers.json?group=#{id} instead
  def notifiers
    render json: RigGroup.find(params[:id]).notifiers, root: false, each_serializer: NotifierSerializer
  end

  # GET /rig_groups/new
  def new
    @rig_group = RigGroup.new
  end

  # GET /rig_groups/1/edit
  def edit
    @rig_group = RigGroup.find(params[:id])
    @rigs = @rig_group.rigs
  end

  # POST /rig_groups
  def create
    rig_group_params[:rig_ids] ||= []
    @rig_group = RigGroup.new(rig_group_params)

    if @rig_group.save
      redirect_to notifiers_path, notice: 'Rig group was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /rig_groups/1
  def update
    rig_group_params[:rig_ids] ||= []
    if @rig_group.update(rig_group_params)
      render json: {message: 'Rig group was successfully updated.'}
    else
      render action: 'edit'
    end
  end

  # DELETE /rig_groups/1
  def destroy
    @rig_group.destroy
    render json: {message: 'ok'}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rig_group
      @rig_group = RigGroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rig_group_params
      params.require(:rig_group).permit(:name, :rig_ids=>[])
    end
end
