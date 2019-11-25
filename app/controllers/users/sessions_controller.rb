class Users::SessionsController < Devise::SessionsController

  prepend_before_action :check_captcha, only: [:create]
  prepend_before_action :customize_sign_in_params, only: [:create]

  private
  def customize_sign_in_params
    devise_parameter_sanitizer.permit :sign_in, keys: [:nickname, :tel, :email, :password, :password_confirmation, :remember_me]
  end

  def check_captcha
    self.resource = resource_class.new sign_in_params
    resource.validate
    unless verify_recaptcha(model: resource)
      respond_with_navigational(resource) { render :new }
    end
  end

end
