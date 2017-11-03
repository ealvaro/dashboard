class EventType
  @@events = []

  def self.events
    @@events
  end

  attr_accessor :id, :name, :description
  def initialize(args={})
    args.each do |k,v|
      self.send("#{k}=", v) if respond_to? "#{k}="
    end
  end

  def self.register(type)
    @@events << type
  end

  def self.find(id)
    for event in @@events
      return event if event.id == id
    end
    nil
  end
end

[
  {id: 1, name: "Configuration - Connection", description: "Occurs when a tool is connected."},
  {id: 2, name: "Configuration - Change", description: "Occurs when a tool’s configuration is changed."},
  {id: 3, name: "Configuration - Push", description: "Occurs when a configuration is pushed to the device from the portal."},
  {id: 4, name: "Memory - Download", description: "Occurs when the user downloads the memory of the tool."},
  {id: 5, name: "Memory - Erase", description: "Occurs when the user erases the memory of the tool."},
  {id: 6, name: "Service - Assembly", description: "Occurs when the tool is first assembled."},
  {id: 7, name: "Service - Firmware Upgrade", description: "Occurs when the LConfig or a user upgrades the firmware of a tool."},
  {id: 8, name: "Service - General", description: "Occurs when the tool is serviced at the electrical level for any reason and is returned to service."},
  {id: 9, name: "Test - HASS - Test Stations", description: "Occurs after the device is HASS screened."},
  {id: 10, name: "Test - Thermal-Stress - Manual Entry", description: "Occurs after a device has been manually tested with thermal stress."},
  {id: 11, name: "Service - Calibration", description: "Occurs when a K-Table is stored to the SI."},
  {id: 12, name: "Status - In Service", description: "Occurs when the tool is marked as in service."},
  {id: 13, name: "Status - In Development", description: "Occurs when the tool is marked as in development."},
  {id: 14, name: "Status - In Repair", description: "Occurs when the tool is marked as in repair."},
  {id: 15, name: "Status - Retired - Preemptive Replacement", description: "Occurs when the tool is permanently removed from service due to natural wear and tear."},
  {id: 16, name: "Status - Retired - Down-hole Failure", description: "Occurs when the tool is permanently removed from service due to a down-hole failure."},
  {id: 17, name: "Status - Retired - Shop Damage", description: "Occurs when the tool is permanently removed from service due to damage from the shop."},
  {id: 18, name: "Warning - Surface Crossover", description: "Occurs when a Dual Gamma experiences a Crossover Event on surface."},
  {id: 19, name: "Report - Upload", description: "Occurs when a file is uploaded the portal."},
  {id: 20, name: "Pump Cycle - Summary", description: "Occurs at the end of the pump cycle when the receiver sends data."},
  {id: 21, name: "File - Upload", description: "Occurs when a tool wants to add a file to its events."}
].each do |hash|
  EventType.register EventType.new(hash)
end
