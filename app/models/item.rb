class Item < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end
end
