FactoryBot.define do
  factory :exchangepost do
    give_item_name { '譲りたいグッズ' }
    give_item_description { '譲りたいグッズの説明' }
    want_item_name { '欲しいグッズ' }
    want_item_description { '欲しいグッズの説明' }
  end
end
