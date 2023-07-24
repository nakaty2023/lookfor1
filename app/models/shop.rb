class Shop < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  validates :address, presence: true, length: { maximum: 255 }
end
