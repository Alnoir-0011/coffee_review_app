FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    sequence(:name, 'testuser')
    password { 'password' }
    password_confirmation { 'password' }
    avatar { File.open(Rails.root.join('public/images/test_avatar.jpg').to_s) }
    role { 'general' }
  end
end
