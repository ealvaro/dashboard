FactoryGirl.define do
  factory :job do
    sequence( :name ) { |n| "OK-%06d" % n }
    association :client
  end
end
