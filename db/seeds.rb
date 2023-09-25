# Users
names = ["テスト太郎", "テスト花子", "きっしー", "ガースー"]
names.each_with_index do |name, i|
  user = User.new(
    name: "#{name}",
    email: "test#{i + 1}@example.com",
    password: "password"
  )
  user.image.attach(io: File.open("./db/seeds/images/avatar_sample#{i}.png"), filename: 'avatar_sample#{i}.png')
  user.save!
end

# Shops(id:18〜27)
#  Shop.where(id: 18..27).to_json(only: [:name, :address, :lat, :lon ], root: true)
#  上記実行結果 >> db/seeds/shops.json
shops_file = File.read(Rails.root.join('db', 'seeds', 'shops.json'))
shops_array = JSON.parse(shops_file)
shops_array.each do |shop|
  Shop.create!(shop['shop'])
end

# Items(id:96〜100)
#  Item.where(id: 96..100).to_json(only: [:name, :url], root: true)
#  上記実行結果 >> db/seeds/items.json
items_file = File.read(Rails.root.join('db', 'seeds', 'items.json'))
items_array = JSON.parse(items_file)
items_array.each do |item|
  Item.create!(item['item'])
end

# Shopitems
#  Shopitem.where(shop_id: 18..27).to_json(only: [:shop_id, :item_id], root: true)
#  上記実行結果 >> db/seeds/shopitems.json
shopitems_file = File.read(Rails.root.join('db', 'seeds', 'shopitems.json'))
shopitems_array = JSON.parse(shopitems_file)
shopitems_array.each do |shopitem|
  Shopitem.create!(shopitem['shopitem'])
end

# Exchangeposts
#  Exchangepost.all.to_json(only: [:give_item_name, :give_item_description, :want_item_name, :want_item_description, :place, user_id], root: true)
#  上記実行結果 >> db/seeds/exchangeposts.json
exchangeposts_file = File.read(Rails.root.join('db', 'seeds', 'exchangeposts.json'))
exchangeposts_array = JSON.parse(exchangeposts_file)
exchangeposts_array.each_with_index do |exchangepost, i|
  exchangepost = Exchangepost.new(exchangepost['exchangepost'])
  exchangepost.images.attach(io: File.open("./db/seeds/images/exchangepost_sample#{i}.jpg"), filename: "exchangepost_sample#{i}.jpg")
  exchangepost.save!
end

# Comments
comments_file = File.read(Rails.root.join('db', 'seeds', 'comments.json'))
comments_array = JSON.parse(comments_file)
comments_array.each do |comment|
  Comment.create!(comment['comment'])
end

# Shopposts
50.times do
  shoppost = Shoppost.new(
    content: "○月○日の○時頃に店舗へ行きましたが、呪術廻戦 懐玉・玉折 ～弐～の▲賞、*賞の在庫ありました！在庫状況のポスターは下記の通りでした！",
    user_id: rand(1..4),
    shop_id: rand(1..10),
  )
  shoppost.images.attach(io: File.open("./db/seeds/images/sample_image.jpeg"), filename: 'sample_image.jpeg')
  shoppost.save!
end
