class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :nickname, :tel, :description, presence: true
  validates :email, :tel, uniqueness: true
  validates :password, :password_confirmation, allow_nil: true, presence: true, length: { minimum: 7 }


  has_many :items
  has_many :likes
  has_many :cards
  belongs_to :exhibits
  belongs_to :transactions
  belongs_to :sale
  belongs_to :user_info
end
