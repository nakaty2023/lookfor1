require 'rails_helper'

RSpec.describe 'UsersExchangeposts', type: :system do
  let(:user) { create(:user, age: 25, gender: 'male') }
  let(:other_user) { create(:user) }
  let(:user_image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
  let(:exchangepost_image) { fixture_file_upload('spec/fixtures/files/sample.png', 'image/png') }
  let!(:user_exchangeposts) { create_list(:exchangepost, 3, user:) }
  let!(:other_user_exchangeposts) { create_list(:exchangepost, 3, user: other_user) }

  describe 'ユーザー別「グッズ交換に関する投稿」一覧の表示' do
    it 'ユーザー名、年齢、性別、画像が表示されること' do
      user.image.attach(user_image)
      visit exchangeposts_user_path(user)
      expect(page).to have_current_path(exchangeposts_user_path(user))
      within '.user-info' do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.age)
        expect(page).to have_content(user.human_attribute_enum(:gender))
        expect(page).to have_selector("img[src$='sample.jpeg']")
      end
    end

    it '店舗に関する投稿一覧ページへのリンク、コメント一覧ページへのリンクが表示されること' do
      visit exchangeposts_user_path(user)
      expect(page).to have_current_path(exchangeposts_user_path(user))
      expect(page).to have_link('店舗に関する投稿', href: user_path(user))
      expect(page).to have_link('コメント', href: comments_user_path(user))
    end

    it 'ユーザーに紐づく投稿一覧が表示されること' do
      user_exchangeposts.each do |exchangepost|
        exchangepost.images.attach(exchangepost_image)
      end
      visit exchangeposts_user_path(user)
      user_exchangeposts.each do |exchangepost|
        within "#exchangepost-#{exchangepost.id}" do
          expect(page).to have_content(user.name)
          expect(page).to have_content(exchangepost.give_item_name)
          expect(page).to have_content(exchangepost.give_item_description)
          expect(page).to have_content(exchangepost.want_item_name)
          expect(page).to have_content(exchangepost.want_item_description)
          expect(page).to have_content(exchangepost.place)
          expect(page).to have_content(exchangepost.created_at.strftime('%Y年%m月%d日'))
          expect(page).to have_content(exchangepost.updated_at.strftime('%Y年%m月%d日'))
          expect(page).to have_selector("img[src$='sample.png']")
          expect(page).to have_link('投稿の詳細を見る', href: exchangepost_path(exchangepost))
        end
      end
    end

    it '他のユーザーの投稿が表示されないこと' do
      visit exchangeposts_user_path(user)
      other_user_exchangeposts.each do |exchangepost|
        expect(page).to_not have_content(exchangepost.give_item_name)
        expect(page).to_not have_content(exchangepost.give_item_description)
        expect(page).to_not have_content(exchangepost.want_item_name)
        expect(page).to_not have_content(exchangepost.want_item_description)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(user)
      end

      it 'ユーザー自身のページに、プロフィール編集リンク、プロフィール詳細リンク、アカウント削除リンクが表示されること' do
        visit exchangeposts_user_path(user)
        expect(page).to have_current_path(exchangeposts_user_path(user))
        within '.user-info' do
          expect(page).to have_link('プロフィールを編集', href: edit_user_registration_path)
          expect(page).to have_link('プロフィール詳細', href: profile_user_path(user))
          expect(page).to have_link('アカウント削除', href: users_path)
        end
      end

      it 'ユーザー自身のページに、投稿削除リンクが表示されること' do
        visit exchangeposts_user_path(user)
        expect(page).to have_current_path(exchangeposts_user_path(user))
        user_exchangeposts.each do |exchangepost|
          expect(page).to have_link('投稿を削除', href: exchangepost_path(exchangepost))
        end
      end

      it '他人のページに、プロフィール編集リンク、プロフィール詳細リンク、アカウント削除リンクが表示されないこと' do
        visit exchangeposts_user_path(other_user)
        expect(page).to have_current_path(exchangeposts_user_path(other_user))
        within '.user-info' do
          expect(page).to_not have_link('プロフィールを編集')
          expect(page).to_not have_link('プロフィール詳細')
          expect(page).to_not have_link('アカウント削除')
        end
      end

      it '他人のページに、投稿削除リンクが表示されないこと' do
        visit exchangeposts_user_path(other_user)
        expect(page).to have_current_path(exchangeposts_user_path(other_user))
        expect(page).to_not have_link('投稿を削除')
      end
    end
  end
end
