FactoryBot.define do
  factory :shoppost do
    sequence(:content) { |n| "テスト投稿#{n}" }
  end
end
