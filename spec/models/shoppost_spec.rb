require 'rails_helper'

RSpec.describe Shoppost, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:shop) { create(:shop) }

    context '投稿内容、店舗id、ユーザーidがある場合' do
      it '有効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        expect(shoppost).to be_valid
      end
    end

    context '店舗idがない場合' do
      it '無効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿')
        expect(shoppost).to_not be_valid
      end
    end

    context '投稿内容がない場合' do
      it '無効な状態である' do
        shoppost = user.shopposts.build(content: '', shop_id: shop.id)
        expect(shoppost).to_not be_valid
      end
    end

    context '投稿文字数が400文字を超過する場合' do
      it '無効な状態である' do
        shoppost = user.shopposts.build(content: 'a' * 401)
        expect(shoppost).to_not be_valid
      end
    end

    context '正しいフォーマット（jpeg）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
      it '有効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        shoppost.images.attach(image)
        expect(shoppost).to be_valid
      end
    end

    context '正しいフォーマット（gif）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.gif', 'image/gif') }
      it '有効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        shoppost.images.attach(image)
        expect(shoppost).to be_valid
      end
    end

    context '正しいフォーマット（png）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.png', 'image/png') }
      it '有効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        shoppost.images.attach(image)
        expect(shoppost).to be_valid
      end
    end

    context '正しいフォーマット（jpg）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpg', 'image/jpg') }
      it '有効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        shoppost.images.attach(image)
        expect(shoppost).to be_valid
      end
    end

    context '誤ったフォーマットの画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.svg', 'image/svg') }
      it '無効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        shoppost.images.attach(image)
        expect(shoppost).to_not be_valid
      end
    end

    context '5MB以上の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/5.5MB.jpeg', 'image/jpeg') }
      it '無効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        shoppost.images.attach(image)
        shoppost.valid?
        expect(shoppost).to_not be_valid
        expect(shoppost.errors[:images]).to include('画像のサイズは5MB以下である必要があります。')
      end
    end

    context '4つの画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
      it '有効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        4.times { shoppost.images.attach(image) }
        expect(shoppost).to be_valid
      end
    end

    context '5つの画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
      it '無効な状態である' do
        shoppost = user.shopposts.build(content: 'テスト投稿', shop_id: shop.id)
        5.times { shoppost.images.attach(image) }
        expect(shoppost).to_not be_valid
      end
    end
  end

  describe '並び順' do
    let(:user) { create(:user) }
    let(:shop) { create(:shop) }

    it '投稿日時の降順で並んでいる' do
      shoppost1 = user.shopposts.create(content: 'テスト投稿1', shop_id: shop.id, created_at: 1.day.ago)
      shoppost2 = user.shopposts.create(content: 'テスト投稿1', shop_id: shop.id, created_at: 2.days.ago)
      shoppost3 = user.shopposts.create(content: 'テスト投稿1', shop_id: shop.id, created_at: 3.days.ago)
      expect(Shoppost.all).to eq([shoppost1, shoppost2, shoppost3])
    end
  end

  describe '画像のバリアント' do
    let(:user) { create(:user) }
    let(:shop) { create(:shop) }
    let(:image) { fixture_file_upload('spec/fixtures/files/large_image.jpeg', 'image/jpeg') }
    let(:shoppost) { create(:shoppost, user:, shop:) }

    it '400×400以内にリサイズされる' do
      shoppost.images.attach(image)
      variant = shoppost.images.first.variant(:display).processed
      image = MiniMagick::Image.read(variant.service.download(variant.key))
      expect(image.width).to be <= 400
      expect(image.height).to be <= 400
    end
  end
end
