FactoryGirl.define do
  factory :region do
    sequence( :name ) { |n| "region name " + n.to_s }
  end

end
