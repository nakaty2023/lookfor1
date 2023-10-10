class ScrapingItemsJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info 'ScrapingItemsJob started'
    scraper = ScrapingItems.new
    items = scraper.fetch_items_for_range(2023, 1, 2024, 12)

    items.each do |item|
      Item.find_or_create_by!(name: item[:name], url: item[:href])
    end

    Item.where.not(name: items.pluck(:name)).delete_all
    Rails.logger.info 'ScrapingItemsJob finished'
  end
end

# 実行方法
# railsコンソールで下記コマンドを実行
# ScrapingItemsJob.perform_now
