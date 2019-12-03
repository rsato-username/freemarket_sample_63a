class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  
  validates :nickname, presence: true # :tel抜かした
  validates :email, uniqueness: true  # :tel抜かした
  validates :tel, uniqueness: true, on: :create
  validates :password, :password_confirmation, allow_nil: true, presence: true, length: { minimum: 7 }

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = User.where(id: snscredential.user_id).first
    else
      user = User.where(email: auth.info.email).first
      if user.present?
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
      else
        user = User.create(
          nickname: auth.info.nickname,
          email:    auth.info.email,
          password: Devise.friendly_token[0, 20],
          tel: ""
          )
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
      end
    end
    return user
  end


  has_many :items
  has_many :likes
  has_many :cards
  has_one :exhibits
  has_one :transactions
  has_one :sale
  has_one :user_info
end
