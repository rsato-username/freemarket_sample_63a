class Users::RegistrationsController < Devise::RegistrationsController

  # prepend_before_action :check_captcha, only: [:create]
  prepend_before_action :customize_sign_up_params, only: [:create]

  # ユーザー新規登録後、rootへリダイレクト
  def after_sign_up_path_for(resource) 
    root_path
  end

  private
  def customize_sign_up_params
    devise_parameter_sanitizer.permit :sign_up, keys: [:nickname, :email, :password, :password_confirmation] 
  end

  # def check_captcha
  #   @user = User.new(params[:user].permit(:nickname, :tel, :email, :password, :password_confirmation))
  #   if verify_recaptcha(model: @user) && @user.save
  #     redirect_to @user
  #   else
  #     render 'new'
  #   end
  # end
  
end
