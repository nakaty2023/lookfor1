class Item < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
end
