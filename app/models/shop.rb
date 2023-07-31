class Shop < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true
  geocoded_by :address, latitude: :lat, longitude: :lon
  after_validation :geocode
end
