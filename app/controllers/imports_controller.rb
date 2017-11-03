class ImportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @imports = Import.all
    @imports_json = ActiveModel::ArraySerializer.new(@imports, each_serializer: ImportSerializer).to_json
    @imports = @imports.decorate
  end

  def new
    @import = Import.new
    @csv_file = @import.csv_files.build
  end

  def create
    @import = Import.new( import_params )
    @csv_file = @import.csv_files.first || @import.csv_files.build
    @import.user = current_user

    @import.valid?
    @csv_file.valid?

    if @import.valid? && @csv_file.valid?
      @import.save
      @csv_file.save
      redirect_to import_run_path( @import )
    else
      @import.decorate
      render :new
    end
  end

  def run
    @import = Import.find( params[:import_id] ).decorate
    Thread.new do
      begin
        @import.run unless @import.finished?
      rescue Exception => e
        logger.fatal e.message
      ensure
        logger.fatal "This is in imports_controller"
        Rails.logger.flush
        ActiveRecord::Base.connection.close
      end
    end
  end

  private

  def import_params
    params.require( :import ).permit( :id, csv_files_attributes: [ :file ] )
  end
end
