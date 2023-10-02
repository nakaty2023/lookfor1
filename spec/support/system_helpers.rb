module SystemHelpers
  def login(user)
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    expect(page).to have_content('ログインしました。')
    expect(current_path).to eq(user_path(user))
    expect(page).to have_content(user.name)
    expect(page).to_not have_link('ログイン')
  end
end

RSpec.configure do |config|
  config.include SystemHelpers, type: :system
end
