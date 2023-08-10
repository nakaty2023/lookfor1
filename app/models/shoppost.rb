class Shoppost < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shop
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true
end
