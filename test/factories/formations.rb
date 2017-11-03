# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :formation do
    sequence( :name ) { |n| "formation name " + n.to_s }
    multiplier 1.0
  end
end
