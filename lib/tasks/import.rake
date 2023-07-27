namespace :import do
  desc 'Import prefectures from lib/data/pref.csv'
  task prefectures: :environment do
    require 'csv'

    path = Rails.root.join('lib/data/pref.csv')
    CSV.foreach(path, headers: true) do |row|
      Prefecture.create!(row.to_hash)
    end
    puts "Imported prefectures from #{path}"
  end
end

namespace :import do
  desc 'Import municipalities from lib/data/municipalities.csv'
  task municipalities: :environment do
    require 'csv'

    path = Rails.root.join('lib/data/municipalities.csv')
    CSV.foreach(path, headers: true) do |row|
      Municipality.create!(row.to_hash)
    end
    puts "Imported municipalities from #{path}"
  end
end
