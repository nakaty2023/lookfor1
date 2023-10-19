require 'rails_helper'

RSpec.describe 'Shopposts', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:shop) { create(:shop) }
  let(:shoppost) { create(:shoppost, user:, shop:) }

  describe 'POST #create' do
    let(:valid_params) { { shoppost: { content: 'Test content', shop_id: shop.id } } }
    let(:invalid_params) { { shoppost: { content: '', shop_id: shop.id } } }

    context '有効なパラメータの場合' do
      it '投稿が保存されること' do
        expect do
          post shopposts_path, params: valid_params
        end.to change(Shoppost, :count).by(1)
        expect(response).to redirect_to shop
        expect(flash[:notice]).to eq I18n.t('shopposts.create.success')
      end
    end

    context '無効なパラメータの場合' do
      it '投稿が保存されないこと' do
        expect do
          post shopposts_path, params: invalid_params
        end.not_to change(Shoppost, :count)
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { shoppost }

    context '投稿の所有者としてログインしている場合' do
      before { sign_in user }

      it '投稿を削除できること' do
        expect do
          delete shoppost_path(shoppost)
        end.to change(Shoppost, :count).by(-1)
        expect(response).to redirect_to shop
        expect(flash[:notice]).to eq I18n.t('shopposts.destroy.success')
      end
    end

    context 'ログインしているが投稿の所有者ではない場合' do
      before { sign_in other_user }

      it '投稿を削除できないこと' do
        expect do
          delete shoppost_path(shoppost)
        end.not_to change(Shoppost, :count)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていない場合' do
      it '投稿を削除できないこと' do
        expect do
          delete shoppost_path(shoppost)
        end.not_to change(Shoppost, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
