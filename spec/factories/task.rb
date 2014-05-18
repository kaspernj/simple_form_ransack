FactoryGirl.define do
  factory :task do
    name { Forgery(:lorem_ipsum).words(4) }
    description { Forgery(:lorem_ipsum).words(100) }
  end
end
