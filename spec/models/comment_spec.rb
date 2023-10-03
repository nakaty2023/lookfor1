require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーション' do
    let(:user) { create(:user) }
    let(:exchangepost) { create(:exchangepost, user:) }

    context 'コメント内容、ユーザーid、グッズ交換投稿idがある場合' do
      let(:comment) { build(:comment, user:, exchangepost:) }
      it '有効な状態である' do
        expect(comment).to be_valid
      end
    end

    context 'コメント内容がない場合' do
      let(:comment) { build(:comment, user:, exchangepost:, content: '') }
      it '無効な状態である' do
        expect(comment).to_not be_valid
      end
    end

    context 'コメント内容が1000文字を超過する場合' do
      let(:comment) { build(:comment, user:, exchangepost:, content: 'a' * 1001) }
      it '無効な状態である' do
        expect(comment).to_not be_valid
      end
    end

    context 'ユーザーidがない場合' do
      let(:comment) { build(:comment, exchangepost:) }
      it '無効な状態である' do
        expect(comment).to_not be_valid
      end
    end

    context 'グッズ交換投稿idがない場合' do
      let(:comment) { build(:comment, user:) }
      it '無効な状態である' do
        expect(comment).to_not be_valid
      end
    end
  end

  describe '並び順' do
    let(:user) { create(:user) }
    let(:exchangepost) { create(:exchangepost, user:) }
    let(:comment1) { create(:comment, user:, exchangepost:, created_at: 1.day.ago) }
    let(:comment2) { create(:comment, user:, exchangepost:, created_at: 2.days.ago) }
    let(:comment3) { create(:comment, user:, exchangepost:, created_at: 3.days.ago) }

    it '投稿日時の降順で並んでいる' do
      expect(Comment.all).to eq([comment1, comment2, comment3])
    end
  end
end
