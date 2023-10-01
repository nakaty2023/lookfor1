require 'rails_helper'

RSpec.describe 'ユーザーログイン', type: :system do
  let(:user) { create(:user) }

  context '有効な値の場合' do
    it 'ログインし、users/showにリダイレクトされること' do
      visit new_user_session_path
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      expect(page).to have_content('ログインしました。')
      expect(current_path).to eq(user_path(user))
      expect(page).to have_content(user.name)
      expect(page).to_not have_link('ログイン')
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

RSpec.describe 'ユーザーログアウト', type: :system, focus: true do
  let(:user) { create(:user) }

  it 'ログアウトできること' do
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    expect(page).to have_content('ログインしました。')
    expect(current_path).to eq(user_path(user))
    expect(page).to have_content(user.name)
    expect(page).to_not have_link('ログイン')
    find('.dropdown-toggle').click
    click_link 'ログアウト'
    expect(page).to have_content('ログアウトしました。')
    expect(current_path).to eq(root_path)
    expect(page).to_not have_content(user.name)
    expect(page).to have_link('ログイン')
    expect(page).to_not have_link('ログアウト')
  end
end
