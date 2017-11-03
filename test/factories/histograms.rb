FactoryGirl.define do
  factory :histogram do
    name "I am a histogram"
    job
    run
    service_number 1
    data { { "Temperature" => { "0-10" => 3, "11-20" => 6 } } }
  end
end
