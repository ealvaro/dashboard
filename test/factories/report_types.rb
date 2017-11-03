FactoryGirl.define do
  factory :report_type do
    sequence( :name ) { |n| "Report Type " + n.to_s }
    active true
  end
end
