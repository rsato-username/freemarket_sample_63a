class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]
  
  validates :nickname, :tel, presence: true
  validates :email, :tel, uniqueness: true
  validates :password, :password_confirmation, allow_nil: true, presence: true, length: { minimum: 7 }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end


  has_many :items
  has_many :likes
  has_many :cards
  # belongs_to :exhibits
  # belongs_to :transactions
  # belongs_to :sale
  # belongs_to :user_info
end
