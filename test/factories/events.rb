FactoryGirl.define do
  factory :event do
    #association( :event_type )
    event_type "Configuration - Connection"
    association( :tool )
    association( :run )
    time DateTime.now
    board_serial_number "1234"
    board_firmware_version "5432"
    reporter_type 0
  end
end
