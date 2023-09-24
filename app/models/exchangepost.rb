class Exchangepost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :images do |attachable|
    attachable.variant :display, resize_to_limit: [400, 400]
  end
  default_scope -> { order(created_at: :desc) }
  validates :give_item_name, presence: true, length: { maximum: 40 }
  validates :give_item_description, presence: true, length: { maximum: 1000 }
  validates :want_item_name, presence: true, length: { maximum: 40 }
  validates :want_item_description, presence: true, length: { maximum: 1000 }
  validates :images, content_type: { in: %w[image/jpeg image/gif image/png image/jpg],
                                     message: :content_type_invalid },
                     size: { less_than: 5.megabytes, message: :byte_size_out_of_range },
                     limit: { min: 0, max: 4, message: :limit_out_of_range }
  def self.ransackable_attributes(auth_object = nil)
    ["give_item_description", "give_item_name", "place", "created_at", "updated_at", "want_item_description", "want_item_name"]
  end
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
