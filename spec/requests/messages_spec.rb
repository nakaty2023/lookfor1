require 'rails_helper'

RSpec.describe 'Messages', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:conversation) { create(:conversation, sender: user, recipient: other_user) }
  let(:message) { create(:message, conversation:, user:) }

  describe 'POST #create' do
    context 'ログインしている場合' do
      before { sign_in user }

      context '有効なパラメータの場合' do
        it 'メッセージが作成されること' do
          expect do
            post conversation_messages_path(conversation), params: { message: { body: 'Test Message' } }
          end.to change(Message, :count).by(1)
          expect(response).to redirect_to(conversation_path(conversation))
        end
      end

      context '無効なパラメータの場合' do
        it 'メッセージが作成されないこと' do
          expect do
            post conversation_messages_path(conversation), params: { message: { body: '' } }
          end.not_to change(Message, :count)
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページへリダイレクトされること' do
        post conversation_messages_path(conversation), params: { message: { body: 'Test Message' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { message }

    context 'ログインしている場合' do
      before { sign_in user }

      it 'メッセージが正常に削除されること' do
        expect do
          delete message_path(message)
        end.to change(Message, :count).by(-1)
        expect(response).to redirect_to(conversation_path(conversation))
        expect(flash[:notice]).to eq I18n.t('messages.destroy.success')
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページへリダイレクトされること' do
        delete message_path(message)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
