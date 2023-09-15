class Shop < ApplicationRecord
  has_many :shopposts, dependent: :destroy
  has_many :shopitems, dependent: :destroy
  has_many :items, through: :shopitems
  validates :name, presence: true
  validates :address, presence: true
  geocoded_by :address, latitude: :lat, longitude: :lon
  after_validation :geocode
  def self.ransackable_attributes(_auth_object = nil)
    %w[address name lat lon]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[items shopitems]
  end
end
