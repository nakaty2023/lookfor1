class Shoppost < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shop
  has_many_attached :images
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true
  validates :images, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: 'must be a valid image format' },
                     size: { less_than: 5.megabytes, message: 'should be less than 5MB' },
                     limit: { min: 0, max: 4, message: 'can attach up to 4 images' }
end
