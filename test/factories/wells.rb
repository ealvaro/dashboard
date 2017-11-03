FactoryGirl.define do
  factory :well do
    sequence( :name) { |n| "Well Name " + n.to_s }
    association( :formation )
  end
end
