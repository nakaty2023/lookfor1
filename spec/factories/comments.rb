FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "テストコメント#{n}" }
  end
end
