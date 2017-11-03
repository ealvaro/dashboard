class ImagesController < ApplicationController
  before_action :find_imageable

  def new
    @image = Image.new(imageable: @imageable)
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to @imageable
    else
      render :new
    end
  end

  def destroy
    @image.find(params[:id]).destroy
  end

  private

  def find_imageable
    @imageable = RunRecord.find_by(id: nil) ||
                 RunRecord.find_by(id: params[:run_record_id]) ||
                 (params[:image][:imageable_type] ? params[:image][:imageable_type].constantize.find(params[:image][:imageable_id]) : nil)
  end

  def image_params
    params.require(:image).permit(:name, :description, :file, :imageable_id, :imageable_type)
  end
end