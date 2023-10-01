require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  context '有効な値の場合' do
    let(:user) { build(:user) }
    it 'ユーザーが登録され、users/showにリダイレクトされること' do
      visit new_user_registration_path
      fill_in 'ユーザー名', with: user.name
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      fill_in 'パスワード（確認用）', with: user.password_confirmation
      click_button 'アカウント登録'
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
