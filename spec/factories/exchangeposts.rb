FactoryBot.define do
  factory :exchangepost do
    sequence(:give_item_name) { |n| "譲りたいグッズ#{n}" }
    sequence(:give_item_description) { |n| "譲りたいグッズ#{n}の説明" }
    sequence(:want_item_name) { |n| "欲しいグッズ#{n}" }
    sequence(:want_item_description) { |n| "欲しいグッズ#{n}の説明" }
    place { '東京都新宿区' }
  end
end
