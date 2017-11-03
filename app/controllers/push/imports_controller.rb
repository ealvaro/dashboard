class Push::ImportsController < ApplicationController
  include TokenAuthenticating
  respond_to :json

  def import_update
    #TODO: put in real code
    @import = Import.find( params[:id] )
    @update = ImportUpdate.new( import: @import, description: params[:message], update_type: params[:update_type] )
    if @update.save
      Pusher["import-#{@import.id}"].trigger("update", @update.description)
      render json: @update
    else
      render json: @update.errors, status: 400
    end
  end

  def import_updates
    @import = Import.find( params[:id] )
    render json: @import.import_updates.order( created_at: :desc )
  end
end
