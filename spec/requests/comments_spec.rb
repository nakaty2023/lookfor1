require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:exchangepost) { create(:exchangepost, user:) }
  let(:comment) { create(:comment, user:, exchangepost:) }

  let(:valid_attributes) do
    {
      content: 'Test Comment',
      exchangepost_id: exchangepost.id
    }
  end

  let(:invalid_attributes) do
    {
      content: '',
      exchangepost_id: exchangepost.id
    }
  end

  describe 'POST #create' do
    context 'ログインしている場合' do
      before { sign_in user }

      context '有効なパラメータの場合' do
        it 'コメントが作成されること' do
          expect do
            post comments_path, params: { comment: valid_attributes }
          end.to change(Comment, :count).by(1)
          expect(response).to redirect_to(exchangepost_path(exchangepost))
          expect(flash[:notice]).to eq I18n.t('comments.create.success')
        end
      end

      context '無効なパラメータの場合' do
        it 'コメントが作成されないこと' do
          expect do
            post comments_path, params: { comment: invalid_attributes }
          end.not_to change(Comment, :count)
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'ログインしていない場合' do
      it 'コメントが作成されず、ログインページにリダイレクトされること' do
        expect do
          post comments_path, params: { comment: valid_attributes }
        end.not_to change(Comment, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'ログインしている場合' do
      before do
        sign_in user
        comment
      end

      it 'コメントが削除されること' do
        expect do
          delete comment_path(comment)
        end.to change(Comment, :count).by(-1)
        expect(response).to redirect_to(exchangepost_path(exchangepost))
        expect(flash[:notice]).to eq I18n.t('comments.destroy.success')
      end
    end

    context 'ログインしていない場合' do
      before do
        comment
      end

      it 'コメントが削除されず、ログインページにリダイレクトされること' do
        expect do
          delete comment_path(comment)
        end.not_to change(Comment, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
