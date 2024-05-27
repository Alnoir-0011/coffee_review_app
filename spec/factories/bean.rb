FactoryBot.define do
  factory :bean do
    sequence(:name) { |n| "testbean_#{n}" }
    roast { 'raw' }
    fineness { 'beans' }
    region_id { 1 }

    trait :roast_medium do
      roast { 'medium' }
    end

    trait :fineness_medium do
      roast { 'medium' }
      fineness { 'medium' }
    end

    trait :with_review do
      transient do
        review_count { 5 }
        user { FactoryBot.create(:user) }
      end
      after(:create) do |bean, evaluator|
        FactoryBot.create_list(:purchase, evaluator.review_count, :with_review, user: evaluator.user, bean:)
      end
    end
  end
end
