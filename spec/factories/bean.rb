FactoryBot.define do
  factory :bean do
    sequence(:name) { |n| "testbean_#{n}" }
    roast { 'raw' }
    fineness { 'beans' }
    region_id { 1 }
  end
end
