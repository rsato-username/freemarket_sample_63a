class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    callback_for(:facebook)
  end

  def google_oauth2
    callback_for(:google)
  end


  private

  def callback_for(provider)
    @user = User.find_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
      @user = User.new()
      render 'first'
      # redirect_to first_signups_path
    end
  end


#========================================================#

  # def callback_for(provider)
  #   @omniauth = request.env['omniauth.auth']
  #   info = User.find_oauth(@omniauth)
  #   @user = info[:user]
  #   if @user.persisted?
  #     sign_in_and_redirect @user, event: :authentication
  #     set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  #   else
  #     @sns = info[:sns]
  #     session[:provider] = info[:sns][:provider]
  #     session[:uid] = info[:sns][:uid]
  #     render step1_signups_path
  #   end
  # end

  #=============================================================#

  def failure
    redirect_to root_path and return
  end
  
end
