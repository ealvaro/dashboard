FactoryGirl.define do
  factory :user do
    name "the-name"
    sequence(:email) {|n| "email#{n}@example.com"}
    password "yo12345"
    password_confirmation "yo12345"
  end
end
