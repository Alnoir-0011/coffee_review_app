FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "title_#{n}" }
    fineness { 'medium' }
    evaluation { 3 }
    content { 'test_review_content'}
    brewing_method_id { 1 }
    purchase
    image { File.open(Rails.root.join('public/images/noimage.jpg').to_s) }
  end
end