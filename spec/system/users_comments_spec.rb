require 'rails_helper'

RSpec.describe 'UsersComments', type: :system do
  let(:user) { create(:user, age: 25, gender: 'male') }
  let(:other_user1) { create(:user) }
  let(:other_user2) { create(:user) }
  let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
  let(:exchangepost) { create(:exchangepost, user: other_user2) }
  let!(:user_comments) { create_list(:comment, 3, user:, exchangepost:) }
  let!(:other_user1_comments) { create_list(:comment, 3, user: other_user1, exchangepost:) }

  describe 'ユーザー別コメント一覧の表示' do
    include ActionView::Helpers::DateHelper

    it 'ユーザー名、年齢、性別、画像が表示されること' do
      user.image.attach(image)
      visit comments_user_path(user)
      expect(page).to have_current_path(comments_user_path(user))
      within '.user-info' do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.age)
        expect(page).to have_content(user.human_attribute_enum(:gender))
        expect(page).to have_selector("img[src$='sample.jpeg']")
      end
    end

    it '店舗に関する投稿一覧ページへのリンク、グッズ交換希望投稿一覧ページへのリンクが表示されること' do
      visit comments_user_path(user)
      expect(page).to have_current_path(comments_user_path(user))
      expect(page).to have_link('店舗に関する投稿', href: user_path(user))
      expect(page).to have_link('グッズ交換希望投稿', href: exchangeposts_user_path(user))
    end

    it 'ユーザーに紐づくコメント一覧及びコメントした投稿の概要が表示されること' do
      visit comments_user_path(user)
      user_comments.each do |comment|
        within "#user-comment-inner-#{comment.id}" do
          expect(page).to have_link(comment.user.name, href: user_path(comment.user))
          expect(page).to have_content(comment.content)
          expect(page).to have_content(time_ago_in_words(comment.created_at))
        end
        within "#user-comment-exchangepost-#{comment.id}" do
          expect(page).to have_link(comment.exchangepost.user.name, href: user_path(comment.exchangepost.user))
          expect(page).to have_content(comment.exchangepost.give_item_name)
          expect(page).to have_content(comment.exchangepost.want_item_name)
          expect(page).to have_link('投稿の詳細を見る', href: exchangepost_path(comment.exchangepost))
        end
      end
    end

    it '他のユーザーのコメントが表示されないこと' do
      visit comments_user_path(user)
      other_user1_comments.each do |comment|
        expect(page).not_to have_selector("div#user-comment-#{comment.id}")
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(user)
      end

      it 'ユーザー自身のページに、プロフィール編集リンク、プロフィール詳細リンク、アカウント削除リンクが表示されること' do
        visit comments_user_path(user)
        expect(page).to have_current_path(comments_user_path(user))
        within '.user-info' do
          expect(page).to have_link('プロフィールを編集', href: edit_user_registration_path)
          expect(page).to have_link('プロフィール詳細', href: profile_user_path(user))
          expect(page).to have_link('アカウント削除', href: users_path)
        end
      end

      it 'ユーザー自身のページに、コメント削除リンクが表示されること' do
        visit comments_user_path(user)
        expect(page).to have_current_path(comments_user_path(user))
        user_comments.each do |comment|
          expect(page).to have_link('削除', href: comment_path(comment))
        end
      end

      it '他人のページに、プロフィール編集リンク、プロフィール詳細リンク、アカウント削除リンクが表示されないこと' do
        visit comments_user_path(other_user1)
        expect(page).to have_current_path(comments_user_path(other_user1))
        within '.user-info' do
          expect(page).to_not have_link('プロフィールを編集')
          expect(page).to_not have_link('プロフィール詳細')
          expect(page).to_not have_link('アカウント削除')
        end
      end

      it '他人のページに、コメント削除リンクが表示されないこと' do
        visit comments_user_path(other_user1)
        expect(page).to have_current_path(comments_user_path(other_user1))
        within '.list-group' do
          expect(page).to_not have_link('削除')
        end
      end
    end
  end
end
