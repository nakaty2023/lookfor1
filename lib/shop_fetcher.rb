def shop_fetcher
  require 'selenium-webdriver'
  require 'nokogiri'

  options = Selenium::WebDriver::Chrome::Options.new
  # options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1280x800')
  ua = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ' \
       'AppleWebKit/537.36 (KHTML, like Gecko) ' \
       'Chrome/115.0.0.0 Safari/537.36'
  options.add_argument("--user-agent=#{ua}")

  driver = Selenium::WebDriver.for(
    :remote,
    url: ENV.fetch('SELENIUM_REMOTE_URL', nil),
    options:
  )

  # 外部サイトにアクセス
  driver.navigate.to 'https://1kuji.com/shop_lists'

  @shops = []
  @shop_items = []

  # 商品を選択
  product_dropdown = driver.find_element(:id, 'product_select')
  product_element = Selenium::WebDriver::Support::Select.new(product_dropdown)
  product_options = product_element.options.reject { |option| option.attribute('value') == 'null' }

  selected_product_options = product_options[0...8] + product_options[9..]

  selected_product_options.each do |product_option|
    product_name = product_option.text.sub('一番くじ ', '')
    @product = Item.find_by(name: product_name)
    product_option.click
    sleep(1)

    # 都道府県を選択
    pref_dropdown = driver.find_element(:id, 'pref_select')
    pref_element = Selenium::WebDriver::Support::Select.new(pref_dropdown)
    pref_options = pref_element.options.select { |option| option.attribute('value') }

    selected_pref_options = [pref_options[13], pref_options[47]]

    selected_pref_options.each do |pref_option|
      pref_option.click
      sleep 1

      # 市町村を選択
      sleep 1 # ページの読み込みを待つための適当な待機時間
      city_dropdown = driver.find_element(:id, 'city_select')
      city_element = Selenium::WebDriver::Support::Select.new(city_dropdown)
      city_options = city_element.options.reject { |option| option.attribute('value') == 'null' }

      selected_city_options = city_options[0..1]

      selected_city_options.each do |city_option|
        city_option.click
        sleep 1

        # 検索ボタンをクリック
        search_button = driver.find_element(:id, 'submit')
        search_button.click

        # 検索結果ページの情報をスクレイピング
        sleep 1 # ページの読み込みを待つための適当な待機時間
        page_source = driver.page_source
        document = Nokogiri::HTML(page_source)
        ul_element = document.at_css('ul#shop_list_update')

        # 店舗名と店舗住所を取得
        ul_element.css('li').each do |li|
          name = li.at_css('h5').text
          address = li.at_css('p.address').text.strip
          google_map_link = driver.find_element(:css, 'a.arrow[href*="https://www.google.com/maps/search/?api=1&query="]').attribute('href')
          match = /query=([\d\.-]+),([\d\.-]+)/.match(google_map_link)
          lat = match[1]
          lon = match[2]
          unless @shops.any? { |shop| shop[:name] == name && shop[:address] == address }
            @shops << { name:, address:, lat:, lon: }
          end
          @shop_items << { shop_name: name, item_id: @product.id }
        end
      end
    end
  end

  current_shopitems = Shopitem.all.map { |si| { shop_id: si.shop_id, item_id: si.item_id } }

  # スクレイピングで取得した情報を保存
  @shops.each do |shop|
    Shop.find_or_create_by!(name: shop[:name], address: shop[:address], lat: shop[:lat], lon: shop[:lon])
  end

  @scraped_shopitems = []
  @shop_items.each do |shop_item|
    shop = Shop.find_by(name: shop_item[:shop_name])
    @scraped_shopitems << { shop_id: shop.id, item_id: shop_item[:item_id] }
    Shopitem.find_or_create_by!(shop_id: shop.id, item_id: shop_item[:item_id])
  end

  # 公式サイトに掲載されなくなった情報は削除
  Shop.where.not(name: @shops.pluck(:name)).delete_all

  old_shopitems = current_shopitems - @scraped_shopitems

  # 削除対象データ等を取得できているかどうか確認
  # puts @shops
  # puts old_shopitems
  # puts current_shopitems
  # puts @scraped_shopitems

  old_shopitems.each do |old_shopitem|
    shopitem = Shopitem.find_by(shop_id: old_shopitem[:shop_id], item_id: old_shopitem[:item_id])
    shopitem&.destroy
  end

  # ブラウザを閉じる
  driver.quit
end

# 実行方法
# railsコンソールで下記コマンドを実行
# require_relative 'lib/shop_fetcher'
# shop_fetcher
