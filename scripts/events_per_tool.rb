require 'csv';

def config_hash
  @hash ||= Hash[Event.all.collect{|e| e.configs.keys}.flatten.uniq.map.with_index.to_a]
end

def configs_hash(event)
  line = []
  config_hash.keys.length.times do
    line << nil
  end
  event.configs.each do |k,v|
    line[config_hash[k]] = v
  end
  line
end

@event_combo_array = []
Event.includes(tool: :tool_type).joins(tool: :tool_type).order( "tools.tool_type_id ASC, events.primary_asset_number ASC, events.hardware_version ASC, events.board_firmware_version ASC" ).each do |event|
  tool = event.tool
  @event_combo_array << {
    tool_type: tool.tool_type.name,
    uid: tool.uid,
    serial_number: tool.serial_number,
    event_type: event.event_type,
    time_of_occurrance: event.time,
    software_installation_id: event.software_installation_id,
    board_firmware_version: event.board_firmware_version,
    board_serial_number: event.board_serial_number,
    chassis_serial_number: event.chassis_serial_number,
    primary_asset_number: event.primary_asset_number,
    user_email: event.user_email,
    region: event.region,
    notes: event.notes,
    created_at: event.created_at,
    updated_at: event.updated_at,
    memory_usage_level: event.memory_usage_level,
    hardware_version: event.hardware_version,
    reporter_version: event.reporter_version,
    reporter_context: event.reporter_context,
    tags: event.tags,
    max_temperature: event.max_temperature,
    max_shock: event.max_shock,
    shock_count: event.shock_count,
  }.merge(configs_hash(event))
end

def headers
  begin
    @headers ||= @event_combo_array.first.keys.map{ |k| k.to_s.titlecase}
  rescue
    @headers ||= []
  end
end

def add_line(line)
  line.values
end

CSV.open("tmp/events_dump_#{Time.now.to_s(:db).gsub(/[- :]/,"")}.csv", "wb") do |csv|
  csv << headers
  @event_combo_array.each do |line|
    csv << add_line(line)
  end
end
