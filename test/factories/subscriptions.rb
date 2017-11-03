FactoryGirl.define do
  factory :subscription do
    association :job
    interests ["RequestCorrection"]
  end
end
