require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  context 'ログイン' do
    context '有効な値の場合' do
      it 'ログインし、users/showにリダイレクトされること' do
        login(user)
        expect(page).to have_link('ログアウト')
      end
    end

    context '無効な値の場合' do
      it 'ログインせず、users/sign_inから別ページへ遷移しないこと' do
        visit new_user_session_path
        fill_in 'Eメール', with: user.email
        fill_in 'パスワード', with: 'invalid'
        click_button 'ログイン'
        expect(page).to have_content('Eメールまたはパスワードが違います。')
        expect(current_path).to eq(new_user_session_path)
        expect(page).to_not have_content(user.name)
        expect(page).to have_link('ログイン')
        expect(page).to_not have_link('ログアウト')
      end
    end
  end

  context 'ゲストログイン' do
    it 'ログインし、トップページへリダイレクトされること' do
      visit root_path
      click_on 'ゲストログイン'
      expect(page).to have_content('ゲストユーザーとしてログインしました。')
      expect(current_path).to eq(root_path)
      expect(page).to have_link('ゲスト', href: user_path(User.find_by(name: 'ゲスト')))
      expect(page).to_not have_link('ログイン')
    end
  end

  context 'ログアウト' do
    it 'ログアウトできること' do
      login(user)
      expect(page).to have_link('ログアウト')
      find('.dropdown-toggle').click
      click_link 'ログアウト'
      expect(page).to have_content('ログアウトしました。')
      expect(current_path).to eq(root_path)
      expect(page).to_not have_content(user.name)
      expect(page).to have_link('ログイン')
      expect(page).to_not have_link('ログアウト')
    end
  end
end
