require 'rails_helper'

RSpec.describe 'Users', type: :request, focus: true do
  let!(:user) { create(:user) }

  describe 'GET #show' do
    it 'HTTPステータスコード200のレスポンスを返すこと' do
      get user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #comments' do
    it 'HTTPステータスコード200のレスポンスを返すこと' do
      get comments_user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #exchangeposts' do
    it 'HTTPステータスコード200のレスポンスを返すこと' do
      get exchangeposts_user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #profile' do
    context 'ユーザーがログインしていない場合' do
      it 'ログインページにリダイレクトすること' do
        get profile_user_path(user)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ユーザーがログインしている場合' do
      before do
        sign_in user
      end

      context 'ログインユーザーの場合' do
        it 'HTTPステータスコード200のレスポンスを返すこと' do
          get profile_user_path(user)
          expect(response).to have_http_status(200)
        end
      end

      context 'ログインユーザー以外の場合' do
        it 'トップページにリダイレクトすること' do
          other_user = create(:user)
          get profile_user_path(other_user)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq '不正なアクセスです。'
        end
      end
    end
  end
end
