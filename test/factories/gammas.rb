# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gamma do
    association :job
    association :run
    sequence( :measured_depth) { |n| 1.0 + n }
    count 321.0
    edited_count 321.0
  end
end
