require 'rails_helper'

RSpec.describe Exchangepost, type: :model, focus: true do
  describe 'バリデーション' do
    let(:user) { create(:user) }

    context '譲りたいグッズ名、譲りたいグッズの説明、欲しい商品、欲しい商品の説明がある場合' do
      let(:exchangepost) { build(:exchangepost, user:) }
      it '有効な状態である' do
        expect(exchangepost).to be_valid
      end
    end

    context '譲りたいグッズ名がない場合' do
      let(:exchangepost) { build(:exchangepost, user:, give_item_name: '') }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '譲りたいグッズ名が40文字を超過する場合' do
      let(:exchangepost) { build(:exchangepost, user:, give_item_name: 'a' * 41) }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '譲りたいグッズの説明がない場合' do
      let(:exchangepost) { build(:exchangepost, user:, give_item_description: '') }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '譲りたいグッズの説明が1000文字を超過する場合' do
      let(:exchangepost) { build(:exchangepost, user:, give_item_description: 'a' * 1001) }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '欲しいグッズ名がない場合' do
      let(:exchangepost) { build(:exchangepost, user:, want_item_name: '') }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '欲しいグッズ名が40文字を超過する場合' do
      let(:exchangepost) { build(:exchangepost, user:, want_item_name: 'a' * 41) }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '欲しいグッズの説明がない場合' do
      let(:exchangepost) { build(:exchangepost, user:, want_item_description: '') }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '欲しいグッズの説明が1000文字を超過する場合' do
      let(:exchangepost) { build(:exchangepost, user:, want_item_description: 'a' * 1001) }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context 'ユーザーidがない場合' do
      let(:exchangepost) { build(:exchangepost) }
      it '無効な状態である' do
        expect(exchangepost).to_not be_valid
      end
    end

    context '正しいフォーマット（jpeg）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
      let(:exchangepost) { build(:exchangepost, user:) }

      it '有効な状態である' do
        exchangepost.images.attach(image)
        expect(exchangepost).to be_valid
      end
    end

    context '正しいフォーマット（gif）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.gif', 'image/gif') }
      let(:exchangepost) { build(:exchangepost, user:) }

      it '有効な状態である' do
        exchangepost.images.attach(image)
        expect(exchangepost).to be_valid
      end
    end

    context '正しいフォーマット（png）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.png', 'image/png') }
      let(:exchangepost) { build(:exchangepost, user:) }

      it '有効な状態である' do
        exchangepost.images.attach(image)
        expect(exchangepost).to be_valid
      end
    end

    context '正しいフォーマット（jpg）の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpg', 'image/jpg') }
      let(:exchangepost) { build(:exchangepost, user:) }

      it '有効な状態である' do
        exchangepost.images.attach(image)
        expect(exchangepost).to be_valid
      end
    end

    context '誤ったフォーマットの画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.svg', 'image/svg') }
      let(:exchangepost) { build(:exchangepost, user:) }

      it '無効な状態である' do
        exchangepost.images.attach(image)
        expect(exchangepost).to_not be_valid
      end
    end

    context '5MB以上の画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/5.5MB.jpeg', 'image/jpeg') }
      let(:exchangepost) { build(:exchangepost, user:) }
      it '無効な状態である' do
        exchangepost.images.attach(image)
        exchangepost.valid?
        expect(exchangepost).to_not be_valid
        expect(exchangepost.errors[:images]).to include('画像のサイズは5MB以下である必要があります。')
      end
    end

    context '4つの画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
      let(:exchangepost) { build(:exchangepost, user:) }
      it '有効な状態である' do
        4.times { exchangepost.images.attach(image) }
        expect(exchangepost).to be_valid
      end
    end

    context '5つの画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
      let(:exchangepost) { build(:exchangepost, user:) }
      it '無効な状態である' do
        5.times { exchangepost.images.attach(image) }
        expect(exchangepost).to_not be_valid
      end
    end
  end

  describe '並び順' do
    let(:user) { create(:user) }
    let(:exchangepost1) { create(:exchangepost, user:, created_at: 1.day.ago) }
    let(:exchangepost2) { create(:exchangepost, user:, created_at: 2.days.ago) }
    let(:exchangepost3) { create(:exchangepost, user:, created_at: 3.days.ago) }

    it '投稿日時の降順で並んでいる' do
      expect(Exchangepost.all).to eq([exchangepost1, exchangepost2, exchangepost3])
    end
  end

  describe '関連する子モデルの削除', focus: true do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:exchangepost) { create(:exchangepost, user:) }
    let!(:comment) { create(:comment, user: other_user, exchangepost:) }

    context 'グッズ交換に関する投稿が削除された場合' do
      it '紐づくコメントが削除される' do
        expect { exchangepost.destroy }.to change { Comment.count }.by(-1)
      end
    end
  end

  describe '画像のバリアント' do
    let(:user) { create(:user) }
    let(:image) { fixture_file_upload('spec/fixtures/files/large_image.jpeg', 'image/jpeg') }
    let(:exchangepost) { create(:exchangepost, user:) }

    it '400×400以内にリサイズされる' do
      exchangepost.images.attach(image)
      variant = exchangepost.images.first.variant(:display).processed
      image = MiniMagick::Image.read(variant.service.download(variant.key))
      expect(image.width).to be <= 400
      expect(image.height).to be <= 400
    end
  end
end
