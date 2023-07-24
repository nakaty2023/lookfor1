require 'nokogiri'
require 'open-uri'

class ScrapingItems
  BASE_URL = "https://1kuji.com/products?sale_month=%d&sale_year=%d"

  def fetch_items_for_range(start_year, start_month, end_year, end_month)
    urls = generate_urls(start_year, start_month, end_year, end_month)
    urls.flat_map { |url| fetch_items_from_url(url) }
  end

  private

  def generate_urls(start_year, start_month, end_year, end_month)
    urls = []

    (start_year..end_year).each do |year|
      start_m = (year == start_year) ? start_month : 1
      end_m = (year == end_year) ? end_month : 12

      (start_m..end_m).each do |month|
        urls << format(BASE_URL, month, year)
      end
    end

    urls
  end

  def fetch_items_from_url(url)
    doc = Nokogiri::HTML(URI.parse(url).open)
    doc.css('.itemList a').map do |node|
      {
        name: node.at_css('.itemName').text.sub('一番くじ ', ''),
        href: node['href']
      }
    end
  end
end
