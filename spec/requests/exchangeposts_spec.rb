require 'rails_helper'

RSpec.describe 'Exchangeposts', type: :request, focus: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:exchangepost) { create(:exchangepost, user:) }
  let(:valid_attributes) do
    {
      give_item_name: 'Give Name',
      give_item_description: 'Give Description',
      want_item_name: 'Want Name',
      want_item_description: 'Want Description',
      place: 'Example Place'
    }
  end

  let(:invalid_attributes) do
    {
      give_item_name: '',
      give_item_description: '',
      want_item_name: '',
      want_item_description: '',
      place: ''
    }
  end

  describe 'GET #index' do
    it 'HTTPステータスコード200のレスポンスを返すこと' do
      get exchangeposts_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    it 'HTTPステータスコード200のレスポンスを返すこと' do
      get exchangepost_path(exchangepost)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do
    context 'ログインしている場合' do
      before { sign_in user }

      it '正常にレスポンスが返されること' do
        get new_exchangepost_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        get new_exchangepost_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'ログインしている場合' do
      before { sign_in user }

      context '有効なパラメータの場合' do
        it 'グッズ交換に関する投稿が作成されること' do
          expect do
            post exchangeposts_path, params: { exchangepost: valid_attributes }
          end.to change(Exchangepost, :count).by(1)
          expect(response).to redirect_to(exchangepost_path(Exchangepost.last))
          expect(flash[:notice]).to eq I18n.t('exchangeposts.create.success')
        end
      end

      context '無効なパラメータの場合' do
        it 'グッズ交換に関する投稿が作成されないこと' do
          expect do
            post exchangeposts_path, params: { exchangepost: invalid_attributes }
          end.not_to change(Exchangepost, :count)
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        post exchangeposts_path, params: { exchangepost: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { exchangepost }

    context '投稿したユーザーがログインしている場合' do
      before { sign_in user }

      it 'グッズ交換に関する投稿が正常に削除されること' do
        expect do
          delete exchangepost_path(exchangepost)
        end.to change(Exchangepost, :count).by(-1)
        expect(response).to redirect_to(exchangeposts_user_path(user))
        expect(flash[:notice]).to eq I18n.t('exchangeposts.destroy.success')
      end
    end

    context '投稿していないユーザーがログインしている場合' do
      before { sign_in other_user }

      it 'グッズ交換に関する投稿を削除できないこと' do
        expect do
          delete exchangepost_path(exchangepost)
        end.not_to change(Exchangepost, :count)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされること' do
        delete exchangepost_path(exchangepost)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
