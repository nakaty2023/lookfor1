require 'rails_helper'

RSpec.describe 'Shops', type: :request do
  let!(:shop) { create(:shop) }

  describe 'GET #index' do
    context '有効な検索パラメータの場合' do
      let(:params) do
        { q_shops: { name_cont: shop.name } }
      end

      it '該当する店舗を返すこと' do
        get(shops_path, params:)
        expect(response).to have_http_status(200)
        expect(response.body).to include(shop.name)
      end
    end

    context '無効な検索パラメータの場合' do
      let(:params) do
        { q_shops: { name_cont: 'invalid' } }
      end

      it 'エラーメッセージが表示されること' do
        get(shops_path, params:)
        expect(response.body).to include('店舗が見つかりませんでした')
      end
    end

    context '検索パラメータが空の場合' do
      it 'トップページへリダイレクトし、エラーメッセージが表示されること' do
        get shops_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('いずれかの入力フォームに、検索条件を入力してください')
      end
    end
  end

  describe 'GET #search' do
    context 'ユーザーの位置情報パラメータが存在する場合' do
      let(:params) do
        { q_shops: { lat: '35.6895', lon: '139.6917' } }
      end

      it 'ユーザー現在地の近隣店舗を返すこと' do
        get(search_shops_path, params:)
        expect(response).to have_http_status(200)
        expect(response.body).to include(shop.name)
      end
    end

    context '位置情報パラメータが存在しない場合' do
      it 'トップページへリダイレクトし、エラーメッセージが表示されること' do
        get search_shops_path
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include('位置情報が取得できませんでした')
      end
    end
  end

  describe 'POST #create' do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          shop: {
            name: 'ローソン 江古田一丁目店',
            address: '東京都中野区江古田１‐４０‐２２'
          }
        }
      end

      it '店舗が作成されること' do
        expect do
          post shops_path, params: valid_params
        end.to change(Shop, :count).by(1)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          shop: {
            name: '',
            address: ''
          }
        }
      end

      it '店舗が作成されないこと' do
        expect do
          post shops_path, params: invalid_params
        end.to_not change(Shop, :count)
      end
    end
  end

  describe 'GET #show' do
    it '店舗の詳細を返すこと' do
      get shop_path(shop)
      expect(response).to have_http_status(200)
      expect(response.body).to include(shop.name)
    end
  end

  describe 'DELETE #destroy' do
    it '店舗を削除すること' do
      expect do
        delete shop_path(shop)
      end.to change(Shop, :count).by(-1)
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(root_path)
    end
  end
end
