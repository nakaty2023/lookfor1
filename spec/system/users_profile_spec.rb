require 'rails_helper'

RSpec.describe 'UserProfile', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'ユーザープロフィール' do
    context 'ログイン後にuser/showへアクセスした場合' do
      before do
        login(user)
        visit profile_user_path(user)
      end

      it 'ユーザー名及びEメールが表示され、パスワードは表示されない' do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.email)
        expect(page).to_not have_content(user.password)
      end

      context '年齢が登録されている場合' do
        let(:user) { create(:user, age: 25) }

        it '年齢が表示される' do
          expect(page).to have_content(user.age)
        end
      end

      context '年齢が登録されていない場合' do
        let(:user) { create(:user, age: nil) }

        it '未登録と表示される' do
          within '.profile-age' do
            expect(page).to have_content('未登録')
          end
        end
      end

      context '性別が登録されている場合' do
        let(:user) { create(:user, gender: 'male') }

        it '性別が表示される' do
          expect(page).to have_content(user.human_attribute_enum(:gender))
        end
      end

      context '性別が登録されていない場合' do
        let(:user) { create(:user, gender: nil) }

        it '未登録と表示される' do
          within '.profile-gender' do
            expect(page).to have_content('未登録')
          end
        end
      end
    end

    context 'ログインせずにuser/showへアクセスした場合' do
      it 'ログインページへリダイレクトされる' do
        visit profile_user_path(user)
        expect(current_path).to eq(new_user_session_path)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
      end
    end

    context 'ログイン後に自分以外のuser/showへアクセスした場合' do
      it 'トップページへリダイレクトされる' do
        login(user)
        visit profile_user_path(other_user)
        expect(current_path).to eq(root_path)
        expect(page).to have_content('不正なアクセスです。')
      end
    end
  end
end
