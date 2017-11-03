class V750::RigsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def index
    render json: Rig.all.order(name: :asc), root: false
  end

  def active
    render json: Rig.active.order(name: :asc), root: false
  end

  def show
    @rig = Rig.find( params[:id] )
    if @rig
      render json: @rig, root: false, serializer: RigSerializer
    else
      render json: "Not Found"
    end
  end

  def destroy
    @rig = Rig.find( params[:id] )
    if @rig
      @rig.destroy
      render json: "Successfully Deleted"
    else
      render json: "Not Found"
    end
  end

  def update
    @rig = Rig.find( params[:id] )
    if @rig.update_attributes( rig_params )
      render json: "Successfully Updated"
    else
      render json: "Not Updated"
    end
  end

  def create
    @rig = Rig.new( rig_params )
    if @rig.save
      render json: "Successfully Created"
    else
      render json: "Not Created"
    end
  end

  private

  def rig_params
    set_valid_params
    params.require( :rig ).permit( :id, :name )
  end
end
