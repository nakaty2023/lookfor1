require 'rails_helper'

RSpec.describe 'UsersRegistrations', type: :system do
  context 'ユーザー登録' do
    context '有効な値の場合' do
      let(:user) { build(:user) }
      it 'ユーザーが登録され、users/showにリダイレクトされること' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: user.name
        fill_in 'Eメール', with: user.email
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード（確認用）', with: user.password_confirmation
        expect { click_button 'アカウント登録' }.to change(User, :count).by(1)
        expect(page).to have_content('アカウント登録が完了しました。')
        expect(current_path).to eq(user_path(User.last))
      end
    end

    context '無効な値の場合' do
      it 'ユーザーが登録されず、users/newから別ページへ遷移しないこと', js: true do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: ''
        fill_in 'Eメール', with: ''
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認用）', with: ''
        click_button 'アカウント登録'
        expect(page).to have_content('ユーザー名を入力してください')
        expect(page).to have_content('Eメールを入力してください')
        expect(page).to have_content('パスワードを入力してください')
        expect(current_path).to eq(new_user_registration_path)
      end
    end
  end

  context 'ユーザープロフィール変更' do
    let(:user) { create(:user) }

    context '有効な値の場合' do
      it 'プロフィールが変更されること' do
        login(user)
        visit edit_user_registration_path
        expect(page).to have_content('プロフィール変更')
        fill_in 'ユーザー名', with: 'Foo Bar'
        fill_in 'Eメール', with: 'foobar@example.com'
        fill_in '現在のパスワード', with: user.password
        click_button '変更する'
        expect(page).to have_content('プロフィールを変更しました。')
        expect(current_path).to eq(profile_user_path(user))
        user.reload
        expect(user.name).to eq('Foo Bar')
        expect(user.email).to eq('foobar@example.com')
      end
    end

    context '無効な値の場合', js: true do
      it 'プロフィールが変更されず、users/editから別ページへ遷移しないこと' do
        login(user)
        visit edit_user_registration_path
        expect(page).to have_content('プロフィール変更')
        fill_in 'ユーザー名', with: ''
        fill_in 'Eメール', with: ''
        fill_in 'パスワード', with: 'foo'
        fill_in 'パスワード（確認用）', with: 'bar'
        fill_in '現在のパスワード', with: 'invalid'
        click_button '変更する'
        expect(page).to have_content('Eメールを入力してください')
        expect(page).to have_content('ユーザー名を入力してください')
        expect(page).to have_content('現在のパスワードは不正な値です')
        expect(page).to have_content('パスワード（確認用）とパスワードの入力が一致しません')
        expect(page).to have_content('パスワードは6文字以上で入力してください')
        expect(current_path).to eq(edit_user_registration_path)
      end
    end

    context 'ログインせずにユーザー編集しようとした場合' do
      it 'ユーザーが登録されず、users/sign_inにリダイレクトされること' do
        visit edit_user_registration_path
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end
