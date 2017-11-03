FactoryGirl.define do
  factory :report_request do
    association( :job )
    association( :requested_by, factory: :user )
    start_depth 500
    end_depth 700
    measured_depth 1000
    inc 1.111
    azm 123.4
    description "FACTORY DESC"
  end
end
