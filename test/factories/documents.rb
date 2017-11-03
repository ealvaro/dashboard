FactoryGirl.define do
  factory :document do
    sequence( :name ) { |n| "Document " + n.to_s }
    association( :report_type )
    active true
  end
end
