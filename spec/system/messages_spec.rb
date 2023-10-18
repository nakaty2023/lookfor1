require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  let(:sender) { create(:user) }
  let(:recipient) { create(:user) }
  let!(:conversation) { create(:conversation, sender:, recipient:) }

  context 'DMの送信' do
    context 'ログイン済みの場合' do
      before do
        login(sender)
        visit user_path(recipient)
        expect(current_path).to eq(user_path(recipient))
        click_on 'DMを送る'
      end

      context '有効な値の場合' do
        it '送信が完了し、conversations/showにメッセージの内容が表示されること' do
          fill_in 'message_body', with: 'テストメッセージ'
          click_button '送信'
          expect(page).to have_text('テストメッセージ')
          expect(current_path).to eq(conversation_path(conversation))
        end
      end

      context '無効な値の場合', js: true do
        it '送信が失敗し、conversations/showにエラーメッセージが表示されること' do
          fill_in 'message_body', with: ''
          click_button '送信'
          expect(page).to have_text('メッセージ内容を入力してください')
          expect(current_path).to eq(conversation_path(conversation))
        end
      end
    end

    context 'ログインしていない場合' do
      it 'DMを送信できないこと' do
        visit user_path(recipient)
        expect(current_path).to eq(user_path(recipient))
        expect(page).to_not have_button('DMを送る')
      end
    end
  end

  describe 'DMの削除' do
    let!(:message) { create(:message, conversation:, user: sender) }

    context 'ログイン済みの場合' do
      it 'DMを削除できること' do
        login(sender)
        visit conversation_path(conversation)
        expect(page).to have_text(message.body)
        click_link '削除'
        expect(page).to_not have_text(message.body)
        expect(page).to have_text('メッセージを削除しました')
        expect(current_path).to eq(conversation_path(conversation))
      end
    end

    context 'ログインしていない場合' do
      it 'DMを削除できないこと' do
        visit conversation_path(conversation)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end
