class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  # password = Devise.friendly_token.first(7)
  #   if session[:provider].present? && session[:uid].present?
  #     @user = User.create(nickname:session[:nickname], email: session[:email], password: "password", password_confirmation: "password", f_name_kana: session[:f_name_kana],l_name_kana: session[:l_name_kana], f_name_kanji: session[:f_name_kanji], l_name_kanji: session[:l_name_kanji], birthday: session[:birthday], tel: params[:user][:tel])
  #     sns = SnsCredential.create(user_id: @user.id,uid: session[:uid], provider: session[:provider])
  #   else
  #     @user = User.create(nickname:session[:nickname], email: session[:email], password: session[:password], password_confirmation: session[:password_confirmation], f_name_kana: session[:f_name_kana],l_name_kana: session[:l_name_kana], f_name_kanji: session[:f_name_kanji], l_name_kanji: session[:l_name_kanji], birthday: session[:birthday], tel: params[:user][:tel])
  #   end

  # def sns
  #   @user = User.new(
  #     nickname: session[:nickname],
  #     email: session[:email],
  #     password: session[:password],
  #     password_confirmation: session[:password],
  #     )
  # end

  # def create
  #   super
  #   @user.uid = session[:uid]
  #   @user.provider = session[:provider]
  #   @user.save
  # end

  def create
    super
    @user.uid = session[:uid]
    @user.provider = session[:provider]
    @user.save

    if verify_recaptcha
      super
    else
      self.resource = resource_class.new
      respond_with_navigational(resource) { render :new }
    end
  end

  

  private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_up_params
        resource.validate # Look for any other validation errors besides Recaptcha
        set_minimum_password_length
        respond_with_navigational(resource) { render :new }
      end 
    end
end