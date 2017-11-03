class ToolDecorator < ApplicationDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages
  delegate_all

  def self.tool_type_attributes
    %i(uid primary_asset_number board_serial_number chassis_serial_number updated_at)
  end

  def self.tool_list_attributes
    last_event_attributes + %i(tool_type_name last_connected)
  end

  def self.last_event_attributes
    %i(uid board_serial_number primary_asset_number job_number run_number reporter_context memory_usage_level hardware_version board_firmware_version max_temperature max_shock shock_count)
  end

  def last_event_attributes
    self.class.last_event_attributes
  end

  def tool_type
    @tool_type ||= object.tool_type
  end

  def tool_type_id
    tool_type.id
  end

  def tool_type_name
    tool_type.name
  end

  last_event_attributes.each do |sym|
    define_method sym do
      send_or_nil( last_event, sym )
    end
  end

  def last_connected
    last_event.nil? ? nil : last_event.time.strftime( "%m-%e-%y %H:%M" )
  end

  def firmware_version
    board_firmware_version
  end

  def asset_number
    primary_asset_number
  end

  def uid
    object.uid_display
  end

  private

  def send_or_nil( object, sym )
    object.nil? ? nil : object.send( sym )
  end
end
