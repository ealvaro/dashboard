class Push::AssetsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def show
    @asset = EventAsset.find(params.fetch(:id))
    render json: @asset, root: false
  rescue ActiveRecord::RecordNotFound
    render text: "Asset Not Found", status: 404
  end
end
