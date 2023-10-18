require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'ユーザー名、メールアドレス、パスワードがある場合' do
      let(:user) { build(:user) }
      it '有効な状態である' do
        expect(user).to be_valid
      end
    end

    context 'ユーザー名が空の場合' do
      let(:user) { build(:user, name: '') }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:name]).to include('を入力してください')
      end
    end

    context 'ユーザー名が空30文字を超過する場合' do
      let(:user) { build(:user, name: 'a' * 31) }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:name]).to include('は30文字以内で入力してください')
      end
    end

    context 'メールアドレスが空の場合' do
      let(:user) { build(:user, email: '') }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include('を入力してください')
      end
    end

    context '既存ユーザーのメールアドレスと重複した場合' do
      let(:existing_user) { create(:user) }
      it '無効な状態である' do
        user = existing_user.dup
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include('はすでに存在します')
      end
    end

    context 'パスワードが短い場合' do
      let(:user) { build(:user, password: 'short', password_confirmation: 'short') }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:password]).to include('は6文字以上で入力してください')
      end
    end

    context 'パスワードと確認が一致しない場合' do
      let(:user) { build(:user, password: 'password123', password_confirmation: 'mismatch') }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
      end
    end

    context '年齢が130を超過する場合' do
      let(:user) { build(:user, age: 131) }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:age]).to include('は130以下の値にしてください')
      end
    end

    context '年齢が負の数値の場合' do
      let(:user) { build(:user, age: -1) }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:age]).to include('は0以上の値にしてください')
      end
    end

    context '年齢が小数の場合' do
      let(:user) { build(:user, age: 30.5) }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:age]).to include('は整数で入力してください')
      end
    end

    context '年齢が文字列の場合' do
      let(:user) { build(:user, age: '文字列') }
      it '無効な状態である' do
        expect(user).to_not be_valid
        expect(user.errors[:age]).to include('は数値で入力してください')
      end
    end

    context '性別が正しい選択肢（男性）の場合' do
      let(:user) { build(:user, gender: 'male') }
      it '有効な状態である' do
        expect(user).to be_valid
      end
    end

    context '性別が正しい選択肢（女性）の場合' do
      let(:user) { build(:user, gender: 'female') }
      it '有効な状態である' do
        expect(user).to be_valid
      end
    end

    context '性別が正しい選択肢（ノンバイナリー）の場合' do
      let(:user) { build(:user, gender: 'non_binary') }
      it '有効な状態である' do
        expect(user).to be_valid
      end
    end

    context '性別が正しい選択肢（無回答）の場合' do
      let(:user) { build(:user, gender: 'no_answer') }
      it '有効な状態である' do
        expect(user).to be_valid
      end
    end

    context '正しいフォーマット（jpeg）のユーザー画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpeg', 'image/jpeg') }
      it '有効な状態である' do
        expect(build(:user, image:)).to be_valid
      end
    end

    context '正しいフォーマット（gif）のユーザー画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.gif', 'image/gif') }
      it '有効な状態である' do
        expect(build(:user, image:)).to be_valid
      end
    end

    context '正しいフォーマット（png）のユーザー画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.png', 'image/png') }
      it '有効な状態である' do
        expect(build(:user, image:)).to be_valid
      end
    end

    context '正しいフォーマット（jpg）のユーザー画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpg', 'image/jpg') }
      it '有効な状態である' do
        expect(build(:user, image:)).to be_valid
      end
    end

    context '誤ったフォーマットのユーザー画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.svg', 'image/svg') }
      it '無効な状態である' do
        user = build(:user, image:)
        user.valid?
        expect(user).to_not be_valid
        expect(user.errors[:image]).to include('は有効な画像形式である必要があります')
      end
    end

    context '5MB以上のユーザー画像がアップロードされる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/5.5MB.jpeg', 'image/jpeg') }
      it '無効な状態である' do
        user = build(:user, image:)
        user.valid?
        expect(user).to_not be_valid
        expect(user.errors[:image]).to include('画像のサイズは5MB以下である必要があります。')
      end
    end
  end

  describe '関連する子モデルの削除' do
    let!(:shop) { create(:shop) }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:exchangepost_attributes) { attributes_for(:exchangepost) }
    let!(:conversation) { create(:conversation, sender_id: user.id, recipient_id: other_user.id) }
    let!(:message) { create(:message, user:, conversation:) }

    context 'ユーザーが削除された場合' do
      it '紐づく店舗に関する投稿が削除される' do
        user.shopposts.create!(content: 'テスト投稿', shop_id: shop.id)
        expect { user.destroy }.to change { Shoppost.count }.by(-1)
      end

      it '紐づくグッズ交換に関する投稿が削除される' do
        user.exchangeposts.create!(exchangepost_attributes)
        expect { user.destroy }.to change { Exchangepost.count }.by(-1)
      end

      it '紐づくコメントが削除される' do
        exchangepost = user.exchangeposts.create!(exchangepost_attributes)
        user.comments.create!(content: 'テストコメント', exchangepost_id: exchangepost.id)
        expect { user.destroy }.to change { Comment.count }.by(-1)
      end

      it '紐づく会話が削除される' do
        expect { user.destroy }.to change { Conversation.count }.by(-1)
      end

      it '紐づくDMが削除される' do
        expect { user.destroy }.to change { Message.count }.by(-1)
      end
    end
  end

  describe '#display_image' do
    let(:user) { build(:user) }

    context 'ユーザー画像が登録されている場合' do
      before do
        user.image.attach(io: File.open('spec/fixtures/files/sample.jpg'), filename: 'sample.jpeg',
                          content_type: 'image/jpeg')
      end

      it '登録されている画像を返す' do
        expect(user.display_image).to eq(user.image)
      end
    end

    context 'ユーザー画像が登録されていない場合' do
      it 'デフォルトアバター画像を返す' do
        expect(user.display_image).to eq('default_avatar.jpg')
      end
    end
  end

  describe '画像のバリアント' do
    let(:user) { create(:user) }
    let(:image) { fixture_file_upload('spec/fixtures/files/large_image.jpeg', 'image/jpeg') }

    it '400×400以内にリサイズされる' do
      user.image.attach(image)
      variant = user.image.variant(:display).processed
      image = MiniMagick::Image.read(variant.service.download(variant.key))
      expect(image.width).to be <= 400
      expect(image.height).to be <= 400
    end
  end
end
