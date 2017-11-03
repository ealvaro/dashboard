FactoryGirl.define do
  factory :tool do
    sequence( :serial_number ) { |n| "serial number #{n}" }
    tool_type
  end
end
