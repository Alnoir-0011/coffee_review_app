FactoryBot.define do
  factory :shop do
    sequence(:name) { |n| "testshop_#{n}" }
    address { 'test_address' }
    sequence(:place_id) { |n| "test_place_id_#{n}" }
    latitude { 35.00 }
    longitude { 135.00 }
    sequence(:google_map_uri) { |n| "test_uri_#{n}" }
  end
end
