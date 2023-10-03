require 'rails_helper'

RSpec.describe 'UsersShow', type: :system, focus: true do
  let(:user) { create(:user, age: 25, gender: 'male') }
  let(:other_user) { create(:user) }
  let(:shop) { create(:shop) }
  let(:user_image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
  let(:shoppost_image) { fixture_file_upload('spec/fixtures/files/sample.png', 'image/png') }
  let!(:user_shopposts) { create_list(:shoppost, 3, user:, shop:) }
  let!(:other_user_shopposts) { create_list(:shoppost, 3, user: other_user, shop:) }

  describe 'ユーザー別「店舗に関する投稿」一覧の表示' do
    include ActionView::Helpers::DateHelper

    it 'ユーザー名、年齢、性別、画像が表示されること' do
      user.image.attach(user_image)
      visit user_path(user)
      expect(page).to have_current_path(user_path(user))
      within '.user-info' do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.age)
        expect(page).to have_content(user.human_attribute_enum(:gender))
        expect(page).to have_selector("img[src$='sample.jpeg']")
      end
    end

    it 'グッズ交換希望投稿一覧ページへのリンク、コメント一覧ページへのリンクが表示されること' do
      visit user_path(user)
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_link('グッズ交換希望投稿', href: exchangeposts_user_path(user))
      expect(page).to have_link('コメント', href: comments_user_path(user))
    end

    it 'ユーザーの投稿が表示されること' do
      user_shopposts.each do |shoppost|
        shoppost.images.attach(shoppost_image)
      end
      visit user_path(user)
      user_shopposts.each do |shoppost|
        within "#user-show-shoppost-#{shoppost.id}" do
          expect(page).to have_content(shoppost.user.name)
          expect(page).to have_link(shoppost.shop.name, href: shop_path(shoppost.shop))
          expect(page).to have_content(shoppost.content)
          expect(page).to have_selector("img[src$='sample.png']")
          expect(page).to have_content(time_ago_in_words(shoppost.created_at))
        end
      end
    end

    it '他のユーザーの投稿が表示されないこと' do
      visit user_path(user)
      other_user_shopposts.each do |shoppost|
        expect(page).to_not have_content(shoppost.user.name)
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
          expect(page).to have_link('プロフィールを編集', href: edit_user_registration_path)
          expect(page).to have_link('プロフィール詳細', href: profile_user_path(user))
          expect(page).to have_link('アカウント削除', href: users_path)
        end
      end

      it 'ユーザー自身のページに、投稿削除リンクが表示されること' do
        visit user_path(user)
        expect(page).to have_current_path(user_path(user))
        user_shopposts.each do |shoppost|
          expect(page).to have_link('削除', href: shoppost_path(shoppost))
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

      it '他人のページに、投稿削除リンクが表示されないこと' do
        visit user_path(other_user)
        expect(page).to have_current_path(user_path(other_user))
        within '.list-group' do
          expect(page).to_not have_link('削除')
        end
      end
    end
  end
end
