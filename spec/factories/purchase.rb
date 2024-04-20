FactoryBot.define do
  factory :purchase do
    store_roast_option { 'light' }
    store_grind_option { 'beans' }
    purchase_at { Time.current.yesterday }
    association :user
    association :bean
    association :shop
  end
end
