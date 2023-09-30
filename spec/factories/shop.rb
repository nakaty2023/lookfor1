FactoryBot.define do
  factory :shop do
    name { 'ファミリーマート 東新宿駅西店' }
    address { '東京都新宿区大久保１丁目８番２号' }
    lat { 35.698409 }
    lon { 139.704924 }

    trait :only_name_and_address do
      lat { nil }
      lon { nil }
    end
  end
end
