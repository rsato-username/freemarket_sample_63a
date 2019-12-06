class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  
  validates :nickname, presence: true
  validates :email, uniqueness: true  
  validates :tel, uniqueness: true, length: { maximum: 12 }
  validates :password, presence: true, length: { minimum: 7 }  #:password_confirmation,allow_blank: true 抜かした
  validates :kan_familyname, presence: true
  validates :kan_firstname, presence: true
  validates :kana_familyname, presence: true
  validates :kana_firstname, presence: true
  validates :birthday, presence: true


  def self.without_sns_data(auth)
    password = Devise.friendly_token.first(20)
    user = User.where(email: auth.info.email).first

    if user.present?
      sns = SnsCredential.create(
        uid: auth.uid,
        provider: auth.provider,
        user_id: user.id
      )
    else
      user = User.new(
        email: auth.info.email,
        password: password
      )
      sns = SnsCredential.new(
        uid: auth.uid,
        provider: auth.provider
      )
    end

    return { user: user ,sns: sns}
  end

  def self.with_sns_data(auth, snscredential)
    user = User.where(id: snscredential.user_id).first
    unless user.present?
      user = User.new(
        email: auth.info.email,
        password: Devise.friendly_token.first(20)
      )
    end
    return {user: user}
  end

  def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = with_sns_data(auth, snscredential)[:user]
      sns = snscredential
    else
      user = without_sns_data(auth)[:user]
      sns = without_sns_data(auth)[:sns]
    end
    return { user: user ,sns: sns}
  end



  has_many :items
  has_many :likes
  has_many :card
  has_one :exhibits
  has_one :transactions
  has_one :sale
  has_one :user_info
end
