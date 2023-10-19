FactoryBot.define do
  factory :message do
    conversation { nil }
    user { nil }
    sequence(:body) { |n| "メッセージ#{n}" }
  end
end
