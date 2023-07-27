def shop_fetcher
  require 'selenium-webdriver'
  require 'nokogiri'

  # Chromeのヘッドレスモードのオプションを設定
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu') # 一部のOS/システムでは必要な場合がある

  # ブラウザのインスタンスを開始 (オプションを使用)
  driver = Selenium::WebDriver.for :chrome, options: options

  # 外部サイトにアクセス
  driver.navigate.to 'https://1kuji.com/shop_lists'

  # 商品を選択
  product_name = "一番くじ 呪術廻戦 懐玉・玉折 ～壱～"
  product_dropdown = driver.find_element(:id, 'product_select')
  product_option = Selenium::WebDriver::Support::Select.new(product_dropdown)
  product_option.select_by(:text, product_name)

  # 都道府県を選択
  pref_name = "沖縄県"
  pref_dropdown = driver.find_element(:id, 'pref_select')
  pref_option = Selenium::WebDriver::Support::Select.new(pref_dropdown)
  pref_option.select_by(:text, pref_name)

  # 市町村を選択
  sleep 3 # ページの読み込みを待つための適当な待機時間
  city_name = "那覇市(45)"
  city_dropdown = driver.find_element(:id, 'city_select')
  city_option = Selenium::WebDriver::Support::Select.new(city_dropdown)
  city_option.select_by(:text, city_name)

  # 検索ボタンをクリック
  search_button = driver.find_element(:id, 'submit')
  search_button.click

  # 検索結果ページの情報をスクレイピング
  sleep 3 # ページの読み込みを待つための適当な待機時間
  page_source = driver.page_source
  document = Nokogiri::HTML(page_source)
  ul_element = document.at_css('ul#shop_list_update')

  # 店舗名と店舗住所を取得
  shops = []
  ul_element.css('li').each do |li|
    name = li.at_css('h5').text
    address = li.at_css('p.address').text.strip
    shops << { name: name, address: address }
  end

  # スクレイピングで取得した店舗情報を保存
  shops.each do |shop|
    Shop.find_or_create_by!(name: shop[:name], address: shop[:address])
  end
  # 公式サイトに掲載されなくなった店舗は削除
  Shop.where.not(name: shops.pluck(:name)).delete_all

  # ブラウザを閉じる
  driver.quit
end
