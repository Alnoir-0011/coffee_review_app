FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "title_#{n}" }
    fineness { 'medium' }
    evaluation { 3 }
    content { 'test_review_content' }
    brewing_method_id { 1 }
    association :purchase
    image { File.open(Rails.root.join('public/images/noimage.jpg').to_s) }

    after(:create) do |review, _evaluator|
      review.tools << Tool.first
    end

    trait :grinded do
      fineness { 'grinded' }
      association :purchase, :grind_medium
    end

    trait :with_likes do
      transient do
        like_count { 1 }
      end

      after(:create) do |review, evaluator|
        review.liked_users = FactoryBot.create_list(:user, evaluator.like_count)
      end
    end
  end
end
