require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe 'バリデーション' do
    context '店舗名、住所がある場合' do
      let(:shop) { build(:shop, :only_name_and_address) }
      it '有効な状態である' do
        expect(shop).to be_valid
      end
    end

    context '店舗名が無い場合' do
      let(:shop) { build(:shop, name: '') }
      it '無効な状態である' do
        expect(shop).to_not be_valid
      end
    end

    context '住所が無い場合' do
      let(:shop) { build(:shop, address: '') }
      it '無効な状態である' do
        expect(shop).to_not be_valid
      end
    end
  end

  describe '関連する子モデルの削除' do
    let!(:user) { create(:user) }
    let!(:item) { create(:item) }
    let!(:user) { create(:user) }
    let(:shop) { create(:shop) }

    context '店舗が削除された場合' do
      it '紐づく店舗に関する投稿が削除される' do
        shop.shopposts.create!(content: 'テスト投稿', user_id: user.id)
        expect { shop.destroy }.to change { Shoppost.count }.by(-1)
      end

      it '紐づく店舗取扱商品データが削除される' do
        shop.shopitems.create!(item_id: item.id)
        expect { shop.destroy }.to change { Shopitem.count }.by(-1)
      end
    end
  end
end
