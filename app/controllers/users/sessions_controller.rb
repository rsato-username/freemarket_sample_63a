class Users::SessionsController < Devise::SessionsController

  # prepend_before_action :check_captcha, only: :create
  prepend_before_action :customize_sign_in_params, only: :create

  

  private
  def customize_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  # def check_captcha
  #   unless verify_recaptcha
  #     @user = User.new(params[:user].permit(:email, :password))
  #     redirect_to new_user_session_path
  #   end 
  # end

  # def check_captcha
  #   self.user = User.new(params[:user].permit(:email, :password))
  #   user.validate
  #   unless verify_recaptcha(model: user)
  #     respond_with_navigational(user) { render :new }
  #   end
  # end

end
