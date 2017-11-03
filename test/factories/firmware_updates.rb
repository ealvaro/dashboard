FactoryGirl.define do
  sequence(:file) do |n|
    {
      tempfile: StringIO.new('fake file'),
      filename: "#{n}.jpg",
      content_type: 'image/jpg'
    }
  end

  factory :firmware_update do
    tool_type
    version "0.0.1"
    summary ""
    binary { generate(:file) }
    hardware_version "0.0.1"
    contexts ["Admin"]
    regions []
    association( :last_edit_by, factory: :user )
    end
end
