class Shoppost < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shop
  has_many_attached :images
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true
  validates :images, content_type: { in: %w[image/jpeg image/gif image/png image/jpg],
                                     message: :content_type_invalid },
                     size: { less_than: 5.megabytes, message: :byte_size_out_of_range },
                     limit: { min: 0, max: 4, message: :limit_out_of_range }
end
