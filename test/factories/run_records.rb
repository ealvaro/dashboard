# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :run_record do
    association( :tool )
    association( :run )
    max_temperature 1
    item_start_hrs 1.5
    circulating_hrs 1.5
    rotating_hours 1.5
    sliding_hours 1.5
    total_drilling_hours 1.5
    mud_weight 1.5
    gpm 1
    bit_type "MyString"
    motor_bend 1.5
    rpm 1
    chlorides 1
    sand 1
    agitator "Y"
    agitator_distance 1.5
    brt "2014-06-04"
    art "2014-06-04"
  end
end
