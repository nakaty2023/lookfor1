class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable and :rememberable
  has_many :shopposts, dependent: :destroy
  has_many :exchangeposts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [400, 400]
  end
  devise :database_authenticatable, :registerable, :validatable
  enum gender: { 男性: 0, 女性: 1, ノンバイナリー: 2, 無回答: 3 }
  validates :name, presence: true, length: { maximum: 30 }
  validates :age, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 130
  }, allow_blank: true
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png image/jpg],
                                    message: :content_type_invalid },
                    size: { less_than: 5.megabytes, message: '画像のサイズは5MB以下である必要があります。' }

  def display_image
    if image.attached?
      image
    else
      'default_avatar.jpg'
    end
  end
end
