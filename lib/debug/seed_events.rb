class SeedEvents

  def initialize(tool)
    @tool = tool
    @board_serial_number = rand(3000)
  end

  def execute
    5.times do
      fake_random_event
    end
  end

  # {id: 1, name: "Configuration - Connection", description: "Occurs when a tool is connected."},
  # {id: 2, name: "Configuration - Change", description: "Occurs when a tool’s configuration is changed."},
  # {id: 3, name: "Configuration - Push", description: "Occurs when a configuration is pushed to the device from the portal."},
  # {id: 4, name: "Memory - Download", description: "Occurs when the user downloads the memory of the tool."},
  # {id: 5, name: "Flash Memory - Histograms", description: "Assets"},
  # {id: 6, name: "Memory - Erase", description: "Occurs when the user erases the memory of the tool."},
  # {id: 7, name: "Service - Assembly", description: "Occurs when the tool is first assembled."},
  # {id: 8, name: "Service - Firmware Push or Manual Entry", description: "Occurs when the LConfig or a user upgrades the firmware of a tool."},
  # {id: 9, name: "Service - General", description: "Occurs when the tool is serviced at the electrical level for any reason and is returned to service."},
  # {id: 10, name: "Test - HASS - Test Stations", description: "Occurs after the device is HASS screened."},
  # {id: 11, name: "Test - Thermal-Stress - Manual Entry", description: "Occurs after a device has been manually tested with thermal stress."}

  def fake_random_event
    event_type = rand(10) + 1
    event = @tool.events.build
    event.event_type = EventType.events.find{|et| et.id == event_type}.name
    event.time = rand(14).days.ago
    event.reporter_type = "ReporterType"
    event.board_firmware_version = "1.0.0"
    event.board_serial_number = @board_serial_number
    event.primary_asset_number = 1
    event.memory_usage_level = rand(1000)
    event.hardware_version = "1.#{rand(10)}.0"
    event.reporter_version = "2.#{rand(10)}.0"
    event.job_number = "#{rand(1000)}"
    event.user_email = "user@test.com"
    event.notes = "Some notes about this event"
    event.configs = { something: "good" }
    event.save!

    asset = event.event_assets.build
    asset["file"] = "some_file.txt"
    asset.name = "Some File"
    asset.save!
  end

end
