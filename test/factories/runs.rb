FactoryGirl.define do
  factory :run do
    association :job
    association :well
    association :rig
    occurred DateTime.now
    sequence(:number) {|n| n}
  end
end
