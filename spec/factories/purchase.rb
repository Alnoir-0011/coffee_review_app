FactoryBot.define do
  factory :purchase do
    store_roast_option { 'light' }
    store_grind_option { 'beans' }
    purchase_at { Time.current.yesterday }
    association :user
    association :bean
    association :shop

    after(:create) do |purchase, _evaluator|
      purchase.shop.beans << purchase.bean unless purchase.shop.beans.include?(purchase.bean)
    end

    trait :roasted do
      store_roast_option { 'roasted' }
      association :bean, :roast_medium
    end

    trait :grind_medium do
      store_grind_option { 'medium' }
    end

    trait :grinded do
      store_grind_option { 'grinded' }
      association :bean, :fineness_medium
    end

    trait :purchase_at_today do
      purchase_at { Tiem.current.today }
    end

    trait :with_review do
      after(:create) do |purchase, _evaluator|
        purchase.reviews << FactoryBot.create(:review)
        purchase.shop.beans << purchase.bean unless purchase.shop.beans.include?(purchase.bean)
      end
    end
  end
end
