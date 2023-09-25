FactoryBot.define do
  factory :comment do
    content { 'MyText' }
    user { nil }
    exchangepost { nil }
  end
end
