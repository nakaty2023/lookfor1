class Item < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end

  def full_url
    "https://1kuji.com#{url}"
  end
end
