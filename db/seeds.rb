# Users
names = ["yamada", "abe", "tanaka"]
names.each_with_index do |name, i|
  User.create!(
    name: "#{name}",
    email: "test#{i + 1}@example.com",
    password: "password"
  )
end

# Shops(id:18〜27)
#  Shop.where(id: 18..27).to_json(only: [:name, :address, :lat, :lon ], root: true)
#  上記実行結果 >> db/seeds/shops.json
shops_file = File.read(Rails.root.join('db', 'seeds', 'shops.json'))
shops_array = JSON.parse(shops_file)
shops_array.each do |shop|
  Shop.create!(shop['shop'])
end

# Shopitems
#  Shopitem.where(shop_id: 18..27).to_json(only: [:shop_id, :item_id], root: true)
#  上記実行結果 >> db/seeds/shopitems.json
shopitems_file = File.read(Rails.root.join('db', 'seeds', 'shopitems.json'))
shopitems_array = JSON.parse(shopitems_file)
shopitems_array.each do |shopitem|
  Shopitem.create!(shopitem['shopitem'])
end

# Items(id:96〜100)
#  Item.where(id: 96..100).to_json(only: [:name, :url], root: true)
#  上記実行結果 >> db/seeds/items.json
items_file = File.read(Rails.root.join('db', 'seeds', 'items.json'))
items_array = JSON.parse(shops_file)
items_array.each do |item|
  Item.create!(item['item'])
end

# Shopposts
Faker::Config.locale = :ja
50.times do
  shoppost = Shoppost.new(
    content:Faker::Lorem.paragraph(sentence_count: 14),
    user_id: rand(1..3),
    shop_id: rand(1..10),
  )
  shoppost.images.attach(io: File.open("./db/seeds/images/sample_image.jpeg"), filename: 'sample_image.jpeg')
  shoppost.save!
end
