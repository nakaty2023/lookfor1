require 'rails_helper'

RSpec.describe 'Exchangeposts', type: :system, focus: true do
  let(:user) { create(:user, age: 25, gender: 'male') }
  let(:other_user) { create(:user) }
  let!(:exchangepost) { create(:exchangepost, user:) }
  let!(:other_exchangepost) { create(:exchangepost, user: other_user) }

  context 'グッズ交換に関する新規投稿' do
    context 'ログイン済みの場合' do
      before do
        login(user)
        visit root_path
        click_on 'グッズ交換希望　新規投稿'
        expect(current_path).to eq(new_exchangepost_path)
      end

      context '有効な値の場合' do
        it '投稿が完了し、exchangepost/showに投稿内容が表示されること' do
          fill_in 'exchangepost_give_item_name', with: '譲りたいグッズ'
          fill_in 'exchangepost_give_item_description', with: '譲りたいグッズの説明'
          fill_in 'exchangepost_want_item_name', with: '欲しいグッズ'
          fill_in 'exchangepost_want_item_description', with: '欲しいグッズの説明'
          fill_in 'exchangepost_place', with: '東京都渋谷区'
          attach_file('exchangepost_images', 'spec/fixtures/files/sample.jpeg')
          expect { click_button '投稿する' }.to change(Exchangepost, :count).by(1)
          expect(page).to have_content('投稿が完了しました')
          expect(current_path).to eq(exchangepost_path(Exchangepost.first))
          within '.exchangepost-user-info' do
            expect(page).to have_link(user.name, href: user_path(user))
            expect(page).to have_content(user.age)
            expect(page).to have_content(user.human_attribute_enum(:gender))
          end
          within '.exchangepost-info' do
            expect(page).to have_selector("img[src$='sample.jpeg']")
            expect(page).to have_content(Exchangepost.first.give_item_name)
            expect(page).to have_content(Exchangepost.first.give_item_description)
            expect(page).to have_content(Exchangepost.first.want_item_name)
            expect(page).to have_content(Exchangepost.first.want_item_description)
          end
          expect(page).to have_link('投稿を削除', href: exchangepost_path(Exchangepost.first))
          expect(page).to have_content(Exchangepost.first.created_at.strftime('%Y年%m月%d日 %H:%M'))
          expect(page).to have_content(Exchangepost.first.updated_at.strftime('%Y年%m月%d日 %H:%M'))
        end
      end

      context '無効な値の場合' do
        it '投稿が失敗し、exchangepost/showにエラーメッセージが表示されること' do
          fill_in 'exchangepost_give_item_name', with: ''
          fill_in 'exchangepost_give_item_description', with: ''
          fill_in 'exchangepost_want_item_name', with: ''
          fill_in 'exchangepost_want_item_description', with: ''
          attach_file('exchangepost_images', ['spec/fixtures/files/sample.jpeg'] * 5)
          expect { click_button '投稿する' }.to_not change(Exchangepost, :count)
          expect(page).to have_content('譲りたい商品名を入力してください')
          expect(page).to have_content('譲りたい商品の説明を入力してください')
          expect(page).to have_content('欲しい商品名を入力してください')
          expect(page).to have_content('欲しい商品の説明を入力してください')
          expect(page).to have_content('画像は最大4枚まで添付できます')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページへリダイレクトされ、投稿できないこと' do
        visit root_path
        click_on 'グッズ交換希望　新規投稿'
        expect(page).to have_content('ログインもしくはアカウント登録してください。')
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  context 'グッズ交換に関する投稿の削除' do
    # let(:other_user2) { create(:user) }
    # let!(:comment) { create(:comment, user:, exchangepost:) }
    # let!(:other_comment) { create(:comment, user: other_user2, exchangepost:) }

    context 'ログイン済みの場合' do
      before do
        login(user)
      end

      context '自分の投稿の場合' do
        it '削除できること' do
          visit exchangepost_path(exchangepost)
          expect(current_path).to eq(exchangepost_path(exchangepost))
          expect do
            within ".exchangepost-delete-link" do
              click_on '投稿を削除'
            end
          end.to change(Exchangepost, :count).by(-1)
          expect(page).to have_content('投稿を削除しました')
          expect(current_path).to eq(exchangeposts_user_path(user))
        end
      end

      context '他人の投稿の場合' do
        it '削除できないこと' do
          visit exchangepost_path(other_exchangepost)
          expect(current_path).to eq(exchangepost_path(other_exchangepost))
          expect(page).to_not have_selector("div.exchangepost-delete-link")
          expect(page).to_not have_link("投稿を削除")
        end
      end
    end

    context 'ログインしていない場合' do
      it '削除できないこと' do
        visit exchangepost_path(exchangepost)
        expect(current_path).to eq(exchangepost_path(exchangepost))
        expect(page).to_not have_link('投稿を削除')
        visit exchangepost_path(other_exchangepost)
        expect(current_path).to eq(exchangepost_path(other_exchangepost))
        expect(page).to_not have_link('投稿を削除')
      end
    end
  end
end
