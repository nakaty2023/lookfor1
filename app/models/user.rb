class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable and :rememberable
  has_many :shopposts, dependent: :destroy
  devise :database_authenticatable, :registerable, :validatable
  enum gender: { male: 0, female: 1, non_binary: 2, prefer_not_to_say: 3 }
  validates :name, presence: true, length: { maximum: 30 }
  validates :age, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 130
  }, allow_blank: true
end
