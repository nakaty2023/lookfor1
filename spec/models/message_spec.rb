require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:conversation) { create(:conversation, sender_id: user.id, recipient_id: other_user.id) }

    context 'メッセージ内容がある場合' do
      let(:message) { build(:message, user:, conversation:) }
      it '有効な状態である' do
        expect(message).to be_valid
      end
    end

    context 'メッセージ内容がない場合' do
      let(:message) { build(:message, body: '', user:, conversation:) }
      it '無効な状態である' do
        expect(message).to_not be_valid
        expect(message.errors[:body]).to include('を入力してください')
      end
    end

    context 'user_idがない場合' do
      let(:message) { build(:message, conversation:) }
      it '無効な状態である' do
        expect(message).to_not be_valid
      end
    end

    context 'conversation_idがない場合' do
      let(:message) { build(:message, user:) }
      it '無効な状態である' do
        expect(message).to_not be_valid
      end
    end

    context 'メッセージ内容が1000文字を超過する場合' do
      let(:message) { build(:message, body: 'a' * 1001, user:, conversation:) }
      it '無効な状態である' do
        expect(message).to_not be_valid
        expect(message.errors[:body]).to include('は1000文字以内で入力してください')
      end
    end
  end
end
