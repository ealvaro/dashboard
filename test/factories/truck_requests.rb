FactoryGirl.define do
  factory :truck_request do
    job
    priority "high"
    user_email "some_email@erdosmiller.com"
    computer_identifier "123456789"
    motors "some motor stuff"
    mwd_tools "mwd tools and such"
    surface_equipment "surface equipment and such"
    backhaul "backhaul and such"
  end
end
