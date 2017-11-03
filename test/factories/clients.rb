FactoryGirl.define do
  factory :client do
    sequence( :name ) { |n| "client_name_#{n}" }
  end
end
