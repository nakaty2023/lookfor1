require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# 例: 14分ごとにトップページにHTTP GETリクエストを送信
scheduler.every '14m' do
  require 'net/http'
  uri = URI('https://lookfor1.onrender.com/')
  Net::HTTP.get(uri)
  Rails.logger.info("Regular HTTP GET request sent to #{uri}")
end
