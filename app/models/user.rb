class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable and :rememberable
  has_many :shopposts, dependent: :destroy
  has_many :exchangeposts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :conversations, foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [400, 400]
  end
  devise :database_authenticatable, :registerable, :validatable
  enum gender: { male: 0, female: 1, non_binary: 2, no_answer: 3 }
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

  def self.human_attribute_enum_value(attr_name, key)
    I18n.t("activerecord.enums.#{model_name.i18n_key}.#{attr_name}.#{key}")
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲスト'
    end
  end
end
