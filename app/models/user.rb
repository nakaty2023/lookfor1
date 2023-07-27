class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :recoverable and :rememberable
  devise :database_authenticatable, :registerable, :validatable
end
