require 'rails_helper'

RSpec.describe 'UsersRegistrations', type: :request do
  let!(:user) { create(:user) }
  let!(:guest_user) { create(:user, name: 'ゲスト', email: 'guest@example.com') }

  describe 'POST registrations#create' do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password',
            name: 'Test User',
            gender: '1',
            age: 20
          }
        }
      end

      it 'ユーザーが正常に登録されること' do
        expect do
          post user_registration_path, params: valid_params
        end.to change(User, :count).by(1)
      end

      it 'users/showにリダイレクトすること' do
        post user_registration_path, params: valid_params
        expect(response).to redirect_to(user_path(User.last))
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) do
        {
          user: {
            email: 'invlid',
            password: 'foo',
            password_confirmation: 'bar',
            name: ''
          }
        }
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post user_registration_path, params: invalid_params
        end.to_not change(User, :count)
      end
    end
  end

  describe 'PATCH registrations#update' do
    context 'ユーザーがログインしている場合' do
      context '有効なパラメータの場合' do
        let(:valid_update_params) do
          {
            user: {
              name: 'Updated User',
              email: 'update@example.com',
              gender: '1',
              age: 30,
              current_password: user.password
            }
          }
        end

        context '通常ユーザーの場合' do
          before do
            sign_in user
          end

          it 'プロフィールが正常に更新されること' do
            patch user_registration_path, params: valid_update_params
            user.reload
            expect(user.name).to eq 'Updated User'
            expect(user.email).to eq 'update@example.com'
            expect(user.gender).to eq 'female'
            expect(user.age).to eq 30
          end

          it 'プロフィールページにリダイレクトすること' do
            patch user_registration_path, params: valid_update_params
            expect(response).to redirect_to(profile_user_path(user))
          end
        end

        context 'ゲストユーザーの場合' do
          before do
            sign_in guest_user
          end

          it 'プロフィールページにリダイレクトすること' do
            patch user_registration_path, params: valid_update_params
            expect(response).to redirect_to(root_path)
          end
        end
      end

      context '無効なパラメータの場合' do
        let(:invalid_update_params) do
          {
            user: {
              email: 'invlid',
              name: '',
              gender: 'invalid',
              age: 'invalid',
              current_password: user.password
            }
          }
        end

        before do
          sign_in user
        end

        it 'プロフィールが更新されないこと' do
          expect do
            patch user_registration_path, params: invalid_update_params
          end.to_not change(User, :count)
        end
      end
    end

    context 'ユーザーがログインしていない場合' do
      let(:update_params) do
        {
          user: {
            name: 'Updated User',
            email: 'update@example.com',
            gender: '1',
            age: 30,
            current_password: user.password
          }
        }
      end

      it 'プロフィールが更新されないこと' do
        expect do
          patch user_registration_path, params: update_params
        end.to_not change(User, :count)
      end

      it 'ログインページにリダイレクトすること' do
        patch user_registration_path, params: update_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET registrations#new' do
    context 'ユーザーがログインしている場合' do
      before do
        sign_in user
      end

      it 'トップページにリダイレクトすること' do
        get new_user_registration_path
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'HTTPステータスコード200のレスポンスを返すこと' do
        get new_user_registration_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET registrations#edit' do
    context 'ユーザーがログインしている場合' do
      context '通常ユーザーの場合' do
        before do
          sign_in user
        end

        it 'HTTPステータスコード200のレスポンスを返すこと' do
          get edit_user_registration_path
          expect(response).to have_http_status(200)
        end
      end

      context 'ゲストユーザーの場合' do
        before do
          sign_in guest_user
        end

        it 'トップページにリダイレクトすること' do
          get edit_user_registration_path
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'ログインページにリダイレクトすること' do
        get edit_user_registration_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE registrations#destroy' do
    context 'ユーザーがログインしている場合' do
      context '通常ユーザーの場合' do
        before do
          sign_in user
        end

        it 'ユーザーが削除されること' do
          expect do
            delete users_path
          end.to change(User, :count).by(-1)
        end

        it 'トップページにリダイレクトすること' do
          delete users_path
          expect(response).to redirect_to(root_path)
        end
      end

      context 'ゲストユーザーの場合' do
        before do
          sign_in guest_user
        end

        it 'ユーザーが削除されないこと' do
          expect do
            delete users_path
          end.to_not change(User, :count)
        end

        it 'トップページにリダイレクトすること' do
          delete users_path
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'ユーザーが削除されないこと' do
        expect do
          delete users_path
        end.to_not change(User, :count)
      end

      it 'ログインページにリダイレクトすること' do
        delete users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
