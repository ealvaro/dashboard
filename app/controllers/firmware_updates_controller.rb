class FirmwareUpdatesController < ApplicationController

  before_action :authenticate_user!
  before_action :remove_empty_string_contexts

  def overview
    @firmware_updates = FirmwareUpdate.all.group_by(&:tool_type)
    @type = params[:type]
    if @type.present?
      @firmware_updates.select! do |key, value|
        key == @type
      end
      @firmware_updates[@type] = sort_by_version @firmware_updates[@type]
      @firmware_updates[@type] = Kaminari.paginate_array(@firmware_updates[@type])
                                         .page(params[:page])
    else
      @firmware_updates.each do |key, value|
        @firmware_updates[key] = sort_by_version value
      end
      @firmware_updates.each do |key, value|
        @firmware_updates[key] = value.take(5)
      end
    end
  end

  def new
    @firmware_update = FirmwareUpdate.new
  end

  def create
    @firmware_update = FirmwareUpdate.new firmware_params.merge(last_edit_by_id: current_user.id)
    if @firmware_update.save
      redirect_to overview_firmware_updates_path, notice: "Firmware created!"
    else
      render :new
    end
  end

  def edit
    @firmware_update = FirmwareUpdate.find params[:id]
  end

  def update
    @firmware_update = FirmwareUpdate.find params[:id]
    @firmware_update.attributes = firmware_params.merge(last_edit_by_id: current_user.id)
    if @firmware_update.save
      redirect_to overview_firmware_updates_path, notice: "Firmware created!"
    else
      render :edit
    end

  end

  def confirm_delete
    @firmware_update = FirmwareUpdate.find params[:id]
  end

  def destroy
    @firmware_update = FirmwareUpdate.find params[:id]
    @firmware_update.destroy
    redirect_to overview_firmware_updates_path, notice: "Firmware removed from service"
  end

  private

  def firmware_params
    params.require(:firmware_update).permit(:tool_type, :version, :last_edit_by_id,
                                            :hardware_version, :summary,
                                            :binary, :binary_cache, :for_serial_numbers, :regions => [],
                                            :contexts=>[])
  end

  def remove_empty_string_contexts
    params[:mandate][:contexts].delete_if(&:empty?) if params[:mandate] && params[:mandate][:contexts]
  end

  def sort_by_version(firmware_updates)
    firmware_updates.sort_by { |f| OrderedVersion.new(f.version) }.reverse
  end
end
