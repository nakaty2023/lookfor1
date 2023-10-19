require 'rails_helper'

RSpec.describe 'Conversations', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:conversation) { create(:conversation, sender: user, recipient: other_user) }

  describe 'GET #index' do
    context 'ログインしている場合' do
      context '会話が存在する場合' do
        before do
          sign_in user
          get conversations_path
        end

        it 'HTTPステータスコード200のレスポンスを返すこと' do
          expect(response).to have_http_status(200)
        end
      end

      context '会話が存在しない場合' do
        before do
          sign_in user
          Conversation.delete_all
          get conversations_path
        end

        it 'users/showにリダイレクトされること' do
          expect(response).to redirect_to(user_path(user))
        end

        it 'フラッシュメッセージが表示されること' do
          expect(flash[:notice]).to eq 'DM送信履歴がありません'
        end
      end
    end

    context 'ログインしていない場合' do
      before { get conversations_path }

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    context 'ログインしている場合' do
      context '正しいユーザーの場合' do
        before do
          sign_in user
          get conversation_path(conversation)
        end

        it 'HTTPステータスコード200のレスポンスを返すこと' do
          expect(response).to have_http_status(200)
        end
      end

      context '不正なユーザーの場合' do
        let(:another_user) { create(:user) }

        before do
          sign_in another_user
          get conversation_path(conversation)
        end

        it 'トップページにリダイレクトされること' do
          expect(response).to redirect_to(root_path)
        end

        it 'エラーメッセージが表示されること' do
          expect(flash[:alert]).to eq I18n.t('conversations.show.failure')
        end
      end
    end

    context 'ログインしていない場合' do
      before { get conversation_path(conversation) }

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'ログインしている場合' do
      let(:user2) { create(:user) }
      let(:other_user2) { create(:user) }
      let(:valid_attributes) do
        {
          sender_id: user2.id,
          recipient_id: other_user2.id
        }
      end

      before do
        sign_in user
      end

      it '会話が作成されること' do
        expect do
          post conversations_path, params: { conversation: valid_attributes }
        end.to change(Conversation, :count).by(1)
      end

      it '会話詳細ページにリダイレクトすること' do
        post conversations_path, params: { conversation: valid_attributes }
        expect(response).to redirect_to(conversation_path(Conversation.last))
      end
    end

    context 'ログインしていない場合' do
      before { post conversations_path }

      it 'ログインページにリダイレクトされること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
