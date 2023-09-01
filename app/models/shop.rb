class Shop < ApplicationRecord
  has_many :shopposts, dependent: :destroy
  has_many :shopitems, dependent: :destroy
  has_many :items, through: :shopitems
  validates :name, presence: true
  validates :address, presence: true
  geocoded_by :address, latitude: :lat, longitude: :lon
  after_validation :geocode
end
