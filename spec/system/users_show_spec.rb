require 'rails_helper'

RSpec.describe 'UsersShow', type: :system, focus: true do
  let(:user) { create(:user, age: 25, gender: 'male') }
  let(:other_user) { create(:user) }
  let(:shop) { create(:shop) }
  let!(:user_shopposts) { create_list(:shoppost, 3, user:, shop:) }
  let!(:other_user_shopposts) { create_list(:shoppost, 3, user: other_user, shop:) }

  describe 'ユーザー別「店舗に関する投稿」一覧の表示' do
    it 'ユーザー名、年齢、性別が表示されること' do
      visit user_path(user)
      expect(page).to have_current_path(user_path(user))
      within '.user-info' do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.age)
        expect(page).to have_content(user.human_attribute_enum(:gender))
      end
    end

    it 'ユーザーの投稿が表示されること' do
      visit user_path(user)
      user_shopposts.each do |shoppost|
        expect(page).to have_content(shoppost.content)
      end
    end

    it '他のユーザーの投稿が表示されないこと' do
      visit user_path(user)
      other_user_shopposts.each do |shoppost|
        expect(page).to_not have_content(shoppost.content)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(user)
      end

      it 'ユーザー自身のページに、プロフィール編集リンク、プロフィール詳細リンク、アカウント削除リンクが表示されること' do
        visit user_path(user)
        expect(page).to have_current_path(user_path(user))
        within '.user-info' do
          expect(page).to have_link('プロフィールを編集')
          expect(page).to have_link('プロフィール詳細')
          expect(page).to have_link('アカウント削除')
        end
      end

      it '他人のページに、プロフィール編集リンク、プロフィール詳細リンク、アカウント削除リンクが表示されないこと' do
        visit user_path(other_user)
        expect(page).to have_current_path(user_path(other_user))
        within '.user-info' do
          expect(page).to_not have_link('プロフィールを編集')
          expect(page).to_not have_link('プロフィール詳細')
          expect(page).to_not have_link('アカウント削除')
        end
      end
    end
  end
end
