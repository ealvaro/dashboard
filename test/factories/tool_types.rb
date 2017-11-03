FactoryGirl.define do
  factory :tool_type do
    sequence( :description ) { |n| "tool type name #{n}" }
  end

  factory :pd_tool_type, parent: :tool_type do
    klass "PulserDriver"
    name "Pulser Driver"
  end

  factory :dg_tool_type, parent: :tool_type do
    klass "DualGamma"
    name "Dual Gamma"
  end

  factory :dd_tool_type, parent: :tool_type do
    name "DD"
  end

  factory :smart_battery_tool_type, parent: :tool_type do
    name "Smart Battery"
    klass "SmartBattery"
  end
end