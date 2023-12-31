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

# Exchangeposts, Comments, Conversations, Messages
exchangeposts_file = File.read(Rails.root.join('db', 'seeds', 'exchangeposts.json'))
exchangeposts_array = JSON.parse(exchangeposts_file)
exchangeposts_array.each_with_index do |exchangepost, i|
  users = User.order(Arel.sql('RANDOM()')).limit(2)
  user1 = users[0]
  user2 = users[1]
  exchangepost = user1.exchangeposts.build(exchangepost['exchangepost'])
  exchangepost.images.attach(io: File.open("./db/seeds/images/exchangepost_sample#{i}.jpg"), filename: "exchangepost_sample#{i}.jpg")
  exchangepost.save
  user2.comments.create(
    content: "「*******フィギュア」であれば交換可能ですが、いかがでしょうか？",
    exchangepost_id: Exchangepost.first.id)
  user1.comments.create(
    content: "ぜひ交換させていただきたいです！交換場所や交換日時の詳細はDMしていただけますか？",
    exchangepost_id: Exchangepost.first.id)
  user2.comments.create(
    content: "ご返信ありがとうございます！早速DMしましたので、ご確認よろしくお願いします。",
    exchangepost_id: Exchangepost.first.id)
  conversation = Conversation.between(user1.id, user2.id)
  conversation.messages.create(
    body: "*******フィギュアの交換場所は▲▲▲▲▲でいかがでしょうか？交換日時は○月○日〜○月○日の○○時以降の時間帯でお願いしたいです。",
    user_id: user2.id)
  conversation.messages.create(
    body: "DMありがとうございます。交換場所は▲▲▲▲▲でOKです！交換日時は○月○日の○○時でお願いします。",
    user_id: user1.id)
  conversation.messages.create(
    body: "ご返信ありがとうございました。日時と場所について、承知しました！当日はどうぞよろしくお願いいたします。",
    user_id: user2.id)
end

# Shopposts
50.times do
  user = User.order(Arel.sql('RANDOM()')).first
  shop = Shop.order(Arel.sql('RANDOM()')).first
  shoppost = user.shopposts.build(
    content: "○月○日の○時頃に店舗へ行きましたが、鬼滅の刃 ～襲撃～の▲賞、*賞の在庫ありました！在庫状況のポスターは下記の通りでした！",
    shop_id: shop.id,
  )
  shoppost.images.attach(io: File.open("./db/seeds/images/sample_image.jpeg"), filename: 'sample_image.jpeg')
  shoppost.save
end
