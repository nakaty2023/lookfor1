require 'rails_helper'

RSpec.describe Conversation, type: :model, focus: true do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe 'バリデーション' do
    context '送信者idと受信者idがある場合' do
      let(:conversation) { build(:conversation, sender_id: user.id, recipient_id: other_user.id) }
      it '有効な状態である' do
        expect(conversation).to be_valid
      end
    end

    context '受信者idがない場合' do
      let(:conversation) { build(:conversation, sender_id: user.id, recipient_id: '') }
      it '無効な状態である' do
        expect(conversation).to_not be_valid
      end
    end

    context '送信者idがない場合' do
      let(:conversation) { build(:conversation, sender_id: '', recipient_id: other_user.id) }
      it '無効な状態である' do
        expect(conversation).to_not be_valid
      end
    end

    context '送信者idと受信者idの組み合わせに重複がある場合' do
      let!(:conversation) { create(:conversation, sender_id: user.id, recipient_id: other_user.id) }
      let(:duplicate_conversation) { build(:conversation, sender_id: user.id, recipient_id: other_user.id) }
      it '無効な状態である' do
        expect(duplicate_conversation).to_not be_valid
      end
    end
  end

  describe '.between' do
    let!(:conversation) { create(:conversation, sender_id: user.id, recipient_id: other_user.id) }
    let!(:other_user3) { create(:user) }
    let!(:other_user4) { create(:user) }

    context 'ユーザー２名の会話が既にある場合' do
      it '会話データを返す' do
        expect(Conversation.between(user.id, other_user.id)).to eq conversation
        expect(Conversation.between(other_user.id, user.id)).to eq conversation
      end
    end

    context 'ユーザー２名の会話がない場合' do
      it '会話データを新規作成する' do
        expect do
          Conversation.between(other_user3.id, other_user4.id)
        end.to change(Conversation, :count).by(1)
      end
    end
  end

  describe '#recipient_user_id' do
    let(:conversation) { create(:conversation, sender_id: user.id, recipient_id: other_user.id) }

    context 'ログイン済ユーザーが送信者の場合' do
      it '受信者idを返す' do
        expect(conversation.recipient_user_id(user.id)).to eq other_user.id
      end
    end

    context 'ログイン済ユーザーが受信者の場合' do
      it '送信者idを返す' do
        expect(conversation.recipient_user_id(other_user.id)).to eq user.id
      end
    end
  end
end
