class RigsController < ApplicationController
  before_action :authenticate_user!
  authority_actions :active => 'read'

  def index
    authorize_action_for Rig
    render json: Rig.all.order(name: :asc), root: false
  end

  def active
    authorize_action_for Rig
    render json: Rig.active.order(name: :asc), root: false
  end
end
