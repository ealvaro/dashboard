FactoryGirl.define do
  factory :customer do
    sequence( :name ) { |n| "customer_name_" + n.to_s }
    sequence( :email ) { |n| "customer_email" + n.to_s + "@email.com" }
    association :client
  end
end
