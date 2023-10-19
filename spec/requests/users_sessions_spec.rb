require 'rails_helper'

RSpec.describe 'UsersSessions', type: :request do
  let!(:user) { create(:user) }
  let!(:guest_user) { create(:user, name: 'ゲスト', email: 'guest@example.com') }

  describe 'GET sessions#new' do
    context 'ユーザーがログインしている場合' do
      before do
        sign_in user
      end

      it 'users/showにリダイレクトすること' do
        get new_user_session_path
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'HTTPステータスコード200のレスポンスを返すこと' do
        get new_user_session_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST sessions#create' do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          user: {
            email: user.email,
            password: user.password
          }
        }
      end

      it 'ログインできること' do
        post user_session_path, params: valid_params
        expect(controller.user_signed_in?).to be_truthy
      end

      it 'users/showにリダイレクトすること' do
        post user_session_path, params: valid_params
        expect(response).to redirect_to(user_path(user))
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          user: {
            email: 'invalid',
            password: 'invalid'
          }
        }
      end

      it 'ログインできないこと' do
        post user_session_path, params: invalid_params
        expect(controller.user_signed_in?).to_not be_truthy
      end
    end
  end

  describe 'DELETE sessions#destroy' do
    before do
      sign_in user
    end

    it 'ログアウトできること' do
      delete destroy_user_session_path
      expect(controller.user_signed_in?).to_not be_truthy
    end

    it 'トップページにリダイレクトすること' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST sessions#guest_sign_in' do
    let(:guest_user_params) do
      {
        user: {
          email: guest_user.email,
          password: guest_user.password
        }
      }
    end

    it 'ゲストログインできること' do
      post users_guest_sign_in_path, params: guest_user_params
      expect(controller.user_signed_in?).to be_truthy
    end

    it 'トップページにリダイレクトすること' do
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
