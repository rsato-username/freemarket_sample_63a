class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  
  validates :nickname, :tel, presence: true
  validates :email, :tel, uniqueness: true
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
          nickname: auth.info.name,
          email:    auth.info.email,
          password: Devise.friendly_token[0, 20],
          )
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id
          )
    User.where(provider: auth.provider, uid: auth.uid).first
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.#{provider}_data"] && session["devise.#{provider}_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.#{provider}_data"]
        user.provider = data["provider"] if user.provider.blank?
        user.uid = data["uid"] if user.uid.blank?
        user.password = Devise.friendly_token[0,20] if user.password.blank?
      end
      # binding.pry
    end
  end

  # def self.find_oauth(auth)
  #   uid = auth.uid
  #   provider = auth.provider
  #   snscredential = SnsCredential.where(uid: uid, provider: provider).first
  #   if snscredential.present?
  #     user = User.where(id: snscredential.user_id).first
  #   else
  #     user = User.where(email: auth.info.email).first
  #     if user.present?
  #       SnsCredential.create(
  #         uid: uid,
  #         provider: provider,
  #         user_id: user.id
  #         )
  #     else
  #       user = User.create(
  #         nickname: auth.info.nickname,
  #         email:    auth.info.email,
  #         password: Devise.friendly_token[0, 20],
  #         tel: ""
  #         )
  #       SnsCredential.create(
  #         uid: uid,
  #         provider: provider,
  #         user_id: user.id
  #         )
  #     end
  #   end
  #   return user
  # end



# SNS認証情報がない場合----------------------------
# def self.without_sns_data(auth)
#   user = User.where(email: auth.info.email).first

#   if user.present?
#     sns = SnsCredential.create(
#       uid: auth.uid,
#       provider: auth.provider,
#       user_id: user.id
#     )
#   else
#     user = User.new(
#       nickname: auth.info.name,
#       email: auth.info.email,
#     )
#     sns = SnsCredential.new(
#       uid: auth.uid,
#       provider: auth.provider
#     )
#   end

#   return { user: user ,sns: sns}
# end

# # SNS認証情報がある場合
# def self.with_sns_data(auth, snscredential)
#   user = User.where(id: snscredential.user_id).first
#   unless user.present?
#     user = User.new(
#       nickname: auth.info.name,
#       email: auth.info.email,
#     )
#   end
#   return {user: user}
# end

# def self.find_oauth(auth)
#   uid = auth.uid
#   provider = auth.provider
#   snscredential = SnsCredential.where(uid: uid, provider: provider).first
#   # SNS認証情報があるかないか？
#   if snscredential.present?
#     user = with_sns_data(auth, snscredential)[:user]
#     sns = snscredential
#   else
#     user = without_sns_data(auth)[:user]
#     sns = without_sns_data(auth)[:sns]
#   end
#   return { user: user ,sns: sns}
# end

#------------------------------------------------------

  has_many :items
  has_many :likes
  has_many :cards
  # belongs_to :exhibits
  # belongs_to :transactions
  # belongs_to :sale
  # belongs_to :user_info
end
