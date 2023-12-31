class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :exchangepost
  validates :content, presence: true, length: { maximum: 1000 }
  default_scope -> { order(created_at: :desc) }
end
