FactoryGirl.define do
  factory :rig do
    sequence( :name ) { |n| "Rig Name " + n.to_s }
  end
end
