require 'rails_helper'

RSpec.describe 'Comments', type: :system, focus: true do
  include ActionView::Helpers::DateHelper

  let(:user) { create(:user) }
  let(:other_user1) { create(:user) }
  let(:exchangepost) { create(:exchangepost, user: other_user1) }

  context 'コメントの新規投稿' do
    context 'ログイン済みの場合' do
      before do
        login(user)
        visit exchangepost_path(exchangepost)
      end

      context '有効な値の場合' do
        it '投稿が完了し、exchangepost/showに投稿内容が表示されること' do
          fill_in 'comment_content', with: 'テストコメント'
          expect { click_button 'コメントを送信する' }.to change(Comment, :count).by(1)
          expect(page).to have_content('投稿が完了しました')
          within "#exchangepost-comment-#{Comment.last.id}" do
            expect(page).to have_link(user.name, href: user_path(user))
            expect(page).to have_content(Comment.last.content)
            expect(page).to have_content(time_ago_in_words(Comment.last.created_at))
            expect(page).to have_link('削除', href: comment_path(Comment.last))
          end
        end
      end

      context '無効な値の場合' do
        it '投稿が失敗し、exchangepost/showにエラーメッセージが表示されること', js: true do
          fill_in 'comment_content', with: ''
          expect { click_button 'コメントを送信する' }.to_not change(Comment, :count)
          expect(page).to have_content('コメント内容を入力してください')
          expect(current_path).to eq(exchangepost_path(exchangepost))
        end
      end
    end

    context 'ログインしていない場合' do
      it '投稿が失敗し、ログインページへリダイレクトされること' do
        visit exchangepost_path(exchangepost)
        fill_in 'comment_content', with: 'テストコメント'
        expect { click_button 'コメントを送信する' }.to_not change(Comment, :count)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  context 'コメントの削除' do
    let(:other_user2) { create(:user) }
    let!(:comment) { create(:comment, user:, exchangepost:) }
    let!(:other_comment) { create(:comment, user: other_user2, exchangepost:) }

    context 'ログイン済みの場合' do
      before do
        login(user)
        visit exchangepost_path(exchangepost)
      end

      context '自分のコメントの場合' do
        it '削除できること' do
          expect do
            within "#exchangepost-comment-#{comment.id}" do
              expect(page).to have_content(comment.content)
              click_on '削除'
            end
          end.to change(Comment, :count).by(-1)
          expect(page).to have_content('コメントを削除しました')
          expect(page).to_not have_selector("li#exchangepost-comment-#{comment.id}")
          expect(page).to_not have_content(comment.content)
        end
      end

      context '他人のコメントの場合' do
        it '削除できないこと' do
          within "#exchangepost-comment-#{other_comment.id}" do
            expect(page).to have_content(other_comment.content)
            expect(page).to_not have_link('削除')
          end
        end
      end
    end

    context 'ログインしていない場合' do
      it '削除できないこと' do
        visit exchangepost_path(exchangepost)
        expect(page).to have_content(comment.content)
        expect(page).to have_content(other_comment.content)
        expect(page).to_not have_link('削除', href: comment_path(comment))
        expect(page).to_not have_link('削除', href: comment_path(other_comment))
      end
    end
  end
end
