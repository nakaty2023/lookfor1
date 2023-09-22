class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable and :rememberable
  has_many :shopposts, dependent: :destroy
  has_many :exchangeposts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image
  devise :database_authenticatable, :registerable, :validatable
  enum gender: { 男性: 0, 女性: 1, ノンバイナリー: 2, 無回答: 3 }
  validates :name, presence: true, length: { maximum: 30 }
  validates :age, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 130
  }, allow_blank: true

  def display_image
    if image.attached?
      image
    else
      'default_avatar.jpg'
    end
  end
end
