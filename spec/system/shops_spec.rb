require 'rails_helper'

RSpec.describe 'Shops', type: :system, js: true, focus: true do
  let(:user) { create(:user, age: 25, gender: 'male') }

  context '店舗の検索' do
    let!(:shop1) do
      Shop.create(name: 'セブン‐イレブン 高田馬場２丁目店',
                  address: '東京都新宿区高田馬場２丁目１−２',
                  lat: 35.711707,
                  lon: 139.709737)
    end

    let!(:shop2) do
      Shop.create(name: 'BOOKOFF札幌南2条店',
                  address: '北海道札幌市中央区南二条西1-3',
                  lat: 43.058532,
                  lon: 141.356124)
    end

    let!(:shop3) do
      Shop.create(name: 'ファミリーマート 高田馬場二丁目店',
                  address: '東京都新宿区高田馬場２−１６−１１',
                  lat: 35.714402,
                  lon: 139.705462)
    end

    let!(:item1) { Item.create(name: '呪術廻戦 懐玉・玉折 ～弐～', url: '/products/jujutsu9') }
    let!(:item2) { Item.create(name: '僕のヒーローアカデミア ーVSー', url: '/products/myhero31') }
    let!(:item3) { Item.create(name: '進撃の巨人 ～自由を求めて～', url: '/products/shingeki10') }

    before do
      shop1.items << item1
      shop1.items << item2
      shop2.items << item1
      shop2.items << item3
      shop3.items << item2
      shop3.items << item3
      visit root_path
    end

    context '検索したい店舗が登録されている場合' do
      context '検索条件を入力する場合' do
        it '店舗名で検索できること' do
          fill_in '店舗名', with: 'セブン‐イレブン 高田馬場２丁目店'
          click_on 'shops_search'
          pin = find('map#gmimap0 area', visible: false)
          pin.click
          expect(page).to have_selector('.gm-style-iw')
          within '.gm-style-iw' do
            expect(page).to have_link(shop1.name, href: shop_path(shop1))
            expect(page).to have_content(shop1.address)
            expect(page).to have_content(item1.name)
            expect(page).to have_content(item2.name)
            expect(page).to have_link('現在地からのルート', href: "https://www.google.com/maps/dir/current+location/#{shop1.address}")
            expect(page).to have_link('店舗に関する投稿', href: shop_path(shop1))
          end
          expect(page).to have_selector('map area', visible: false, count: 1)
        end

        it '店舗取扱商品名で検索できること' do
          within '.search-form' do
            fill_in '商品名', with: '僕のヒーローアカデミア'
            click_on 'shops_search'
          end
          pin1 = find('map#gmimap0 area', visible: false)
          pin1.click
          expect(page).to have_selector('.gm-style-iw')
          within '.gm-style-iw' do
            expect(page).to have_link(shop1.name, href: shop_path(shop1))
            expect(page).to have_content(shop1.address)
            expect(page).to have_content(item2.name)
            expect(page).to have_link('現在地からのルート', href: "https://www.google.com/maps/dir/current+location/#{shop1.address}")
            expect(page).to have_link('店舗に関する投稿', href: shop_path(shop1))
          end
          pin2 = find('map#gmimap1 area', visible: false)
          pin2.click
          expect(page).to have_selector('.gm-style-iw')
          within '.gm-style-iw' do
            expect(page).to have_link(shop3.name, href: shop_path(shop3))
            expect(page).to have_content(shop3.address)
            expect(page).to have_content(item2.name)
            expect(page).to have_link('現在地からのルート', href: "https://www.google.com/maps/dir/current+location/#{shop3.address}")
            expect(page).to have_link('店舗に関する投稿', href: shop_path(shop3))
          end
          expect(page).to have_selector('map area', visible: false, count: 2)
        end

        it '店舗住所で検索できること' do
          fill_in '住所', with: '北海道'
          click_on 'shops_search'
          pin = find('map#gmimap0 area', visible: false)
          pin.click
          expect(page).to have_selector('.gm-style-iw')
          within '.gm-style-iw' do
            expect(page).to have_link(shop2.name, href: shop_path(shop2))
            expect(page).to have_content(shop2.address)
            expect(page).to have_content(item1.name)
            expect(page).to have_content(item3.name)
            expect(page).to have_link('現在地からのルート', href: "https://www.google.com/maps/dir/current+location/#{shop2.address}")
            expect(page).to have_link('店舗に関する投稿', href: shop_path(shop2))
          end
          expect(page).to have_selector('map area', visible: false, count: 1)
        end
      end

      context '検索条件を入力しない場合' do
        it '検索結果が表示されないこと' do
          click_on 'shops_search'
          expect(page).to have_content('いずれかの入力フォームに、検索条件を入力してください')
        end
      end
    end

    context '検索したい店舗が登録されていない場合' do
      it '検索結果が表示されないこと' do
        within '.search-form' do
          fill_in '商品名', with: 'ワンピース'
          click_on 'shops_search'
        end
        expect(page).to have_content('店舗が見つかりませんでした')
      end
    end
  end
end
