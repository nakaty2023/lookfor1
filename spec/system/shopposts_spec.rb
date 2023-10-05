require 'rails_helper'

RSpec.describe 'Shopposts', type: :system do
  include ActionView::Helpers::DateHelper

  let(:user) { create(:user) }
  let(:shop) { create(:shop) }

  context '店舗に関する新規投稿' do
    before do
      login(user)
      visit shop_path(shop)
    end

    context '有効な値の場合' do
      it '投稿が完了し、shop/showに投稿内容が表示されること' do
        fill_in 'shoppost_content', with: 'テスト投稿'
        attach_file('shoppost_images', 'spec/fixtures/files/sample.jpeg')
        expect { click_button '投稿' }.to change(Shoppost, :count).by(1)
        expect(page).to have_content('投稿が完了しました')
        within "#shop-show-shoppost-#{Shoppost.first.id}" do
          expect(page).to have_link(user.name, href: user_path(user))
          expect(page).to have_content(Shoppost.first.content)
          expect(page).to have_content(time_ago_in_words(Shoppost.first.created_at))
          expect(page).to have_selector("img[src$='sample.jpeg']")
          expect(page).to have_link('削除', href: shoppost_path(Shoppost.first))
        end
      end
    end

    context '無効な値の場合' do
      it '投稿が失敗し、shop/showにエラーメッセージが表示されること' do
        fill_in 'shoppost_content', with: ''
        attach_file('shoppost_images', ['spec/fixtures/files/sample.jpeg'] * 5)
        expect { click_button '投稿' }.to_not change(Shoppost, :count)
        expect(page).to have_content('投稿内容を入力してください')
        expect(page).to have_content('画像は最大4枚まで添付できます')
        expect(page).to_not have_selector("img[src$='sample.jpeg']")
      end
    end
  end

  context '店舗に関する投稿の削除' do
    let!(:shoppost) { create(:shoppost, user:, shop:) }
    let(:other_user) { create(:user) }
    let!(:other_shoppost) { create(:shoppost, user: other_user, shop:) }

    before do
      login(user)
      visit shop_path(shop)
    end

    context '自分の投稿の場合' do
      it '削除できること' do
        expect do
          within "#shop-show-shoppost-#{shoppost.id}" do
            expect(page).to have_content(shoppost.content)
            click_on '削除'
          end
        end.to change(Shoppost, :count).by(-1)
        expect(page).to have_content('投稿を削除しました')
        expect(page).to_not have_selector("li#shop-show-shoppost-#{shoppost.id}")
        expect(page).to_not have_content(shoppost.content)
      end
    end

    context '他人の投稿の場合' do
      it '削除できないこと' do
        within "#shop-show-shoppost-#{other_shoppost.id}" do
          expect(page).to have_content(other_shoppost.content)
          expect(page).to_not have_link('削除')
        end
      end
    end
  end
end
