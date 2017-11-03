class SoftwareController < ApplicationController

  before_action :authenticate_user!, except: :latest

  def overview
    @software = Software.all
  end

  def previous
    @software = SoftwareType.find(params[:software_type_id]).software
  end

  def new
    @software = Software.new
  end

  def create
    @software = Software.new software_params
    if @software.save
      redirect_to overview_software_index_path, notice: "software created!"
    else
      render :new
    end
  end

  def edit
    @software = Software.find params[:id]
  end

  def update
    @software = Software.find params[:id]
    @software.attributes = software_params
    if @software.save
      redirect_to overview_software_index_path, notice: "software updated!"
    else
      render :edit
    end

  end

  def confirm_delete
    @software = Software.find params[:id]
  end

  def destroy
    @software = Software.find params[:id]
    @software.destroy
    redirect_to overview_software_index_path,
                notice: "software removed from service"
  end

  def latest
    software_type = SoftwareType.find_by("lower(name) = ?", params[:software_type].try( :downcase ) )
    types = software_type.software.sort_by{|a| OrderedVersion.new(a.version)}
    @latest_software = types.reverse.first

    redirect_to @latest_software.binary.url
  end

  private

  def software_params
    params.require(:software).permit(:software_type_id, :version,
                                            :summary, :installer_name)
  end
end
