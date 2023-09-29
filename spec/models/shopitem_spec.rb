require 'rails_helper'

RSpec.describe Shopitem, type: :model do
  describe 'バリデーション', focus: true do
    let(:shop) { create(:shop) }
    let(:item) { create(:item) }

    context '店舗id、グッズidがある場合' do
      let(:shopitem) { build(:shopitem, shop_id: shop.id, item_id: item.id) }
      it '有効な状態である' do
        expect(shopitem).to be_valid
      end
    end

    context '店舗idがない場合' do
      let(:shopitem) { build(:shopitem, shop_id: '', item_id: item.id) }
      it '無効な状態である' do
        expect(shopitem).to_not be_valid
      end
    end

    context 'グッズidがない場合' do
      let(:shopitem) { build(:shopitem, shop_id: shop.id, item_id: '') }
      it '無効な状態である' do
        expect(shopitem).to_not be_valid
      end
    end
  end
end
