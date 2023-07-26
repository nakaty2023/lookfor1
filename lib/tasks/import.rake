namespace :import do
  desc 'Import prefectures from lib/data/pref.csv'
  task prefectures: :environment do
    require 'csv'

    path = Rails.root.join('lib', 'data', 'pref.csv')
    CSV.foreach(path, headers: true) do |row|
      Prefecture.create!(row.to_hash)
    end
    puts "Imported prefectures from #{path}"
  end
end
