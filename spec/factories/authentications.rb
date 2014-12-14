FactoryGirl.define do
  factory :authentication do
    user
    provider "facebook"
    uid { Faker::Code.isbn }
    access_token { Faker::Code.isbn }
  end
end
