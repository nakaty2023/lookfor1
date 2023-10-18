require 'rails_helper'

RSpec.describe 'Conversations', type: :system do
  let(:user) { create(:user) }
  let(:other_user1) { create(:user) }
  let(:other_user2) { create(:user) }
  let(:other_user3) { create(:user) }
  let!(:conversation1) { create(:conversation, sender: user, recipient: other_user1) }
  let!(:conversation2) { create(:conversation, sender: user, recipient: other_user2) }

  describe '会話の開始' do
    context 'ログイン済みの場合' do
      before do
        login(user)
        visit user_path(other_user3)
      end

      it '新しい会話が作成され、その会話の詳細ページにリダイレクトされる' do
        expect(current_path).to eq(user_path(other_user3))
        expect { click_on 'DMを送る' }.to change(Conversation, :count).by(1)
        expect(current_path).to eq(conversation_path(Conversation.last))
        expect(page).to have_content(other_user3.name)
      end
    end

    context 'ログインしていない場合' do
      it '会話を開始できない' do
        visit user_path(user)
        expect(current_path).to eq(user_path(user))
        expect(page).to_not have_button('DMを送る')
      end
    end
  end

  describe '会話一覧の表示' do
    context 'ログイン済みの場合' do
      context '会話履歴がある場合' do
        it '会話一覧が表示される' do
          login(user)
          visit conversations_path
          expect(page).to have_link(other_user1.name, href: conversation_path(conversation1))
          expect(page).to have_link(other_user2.name, href: conversation_path(conversation2))
        end
      end

      context '会話履歴がない場合' do
        it '会話一覧が表示されず、ユーザー詳細ページへリダイレクトされる' do
          login(other_user3)
          visit conversations_path
          expect(page).to have_content('DM送信履歴がありません')
          expect(current_path).to eq(user_path(other_user3))
        end
      end
    end

    context 'ログインしていない場合' do
      it '会話一覧が表示されず、ログインページにリダイレクトされる' do
        visit conversations_path
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe '会話の詳細表示' do
    let!(:message1) { create(:message, user:, conversation: conversation1) }
    let!(:message2) { create(:message, user: other_user1, conversation: conversation1) }

    context 'ログイン済みの場合' do
      context '対象の会話に参加しているユーザーの場合' do
        before do
          login(user)
          visit conversation_path(conversation1)
        end

        it 'DMの内容が表示される' do
          expect(page).to have_content(message1.body)
          expect(page).to have_content(message2.body)
        end
      end

      context '対象の会話に参加していないユーザーの場合' do
        before do
          login(other_user3)
          visit conversation_path(conversation1)
        end

        it 'トップページにリダイレクトされ、エラーメッセージが表示される' do
          expect(page).to have_content('アクセス権限がありません')
          expect(current_path).to eq(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it '会話の詳細が表示されず、ログインページにリダイレクトされる' do
        visit conversation_path(conversation1)
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end
