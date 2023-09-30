class Shoppost < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :shop
  has_many_attached :images do |attachable|
    attachable.variant :display, resize_to_limit: [400, 400]
  end
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: { maximum: 400 }
  validates :images, content_type: { in: %w[image/jpeg image/gif image/png image/jpg],
                                     message: :content_type_invalid },
                     size: { less_than: 5.megabytes, message: '画像のサイズは5MB以下である必要があります。' },
                     limit: { min: 0, max: 4, message: :limit_out_of_range }
end
