FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'user@example.com' }
    password { 'password123' }
    password_confirmation { 'password123' }
  end
end
