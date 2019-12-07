class SignupsController < ApplicationController
  # before_action :save_to_session_user, only: :second
  before_action :get_payjp_info, only: :create
  before_action :validates_first, only: :second
  before_action :validates_second, only: :forth
  before_action :validates_forth, only: :fifth

  
  def index
  end

  def first
    @user = User.new(
      password: Devise.friendly_token.first(20)
    )
  end

  def second
    # session[:nickname] = user_params[:nickname]
    # session[:email] = user_params[:email]
    # session[:password] = user_params[:password]
    # session[:kan_familyname] = user_params[:kan_familyname]
    # session[:kan_firstname] = user_params[:kan_firstname]
    # session[:kana_familyname] = user_params[:kana_familyname]
    # session[:kana_firstname] = user_params[:kana_firstname]
    # session[:birthday] = user_params['birthday(1i)'] + "/" + user_params['birthday(2i)'] + "/" + user_params['birthday(3i)']

    @user = User.new
  end

  def third
  end

  def forth
    # session[:tel] = user_params[:tel]
    @user_info = UserInfo.new(
      kan_familyname: session[:kan_familyname],
      kan_firstname: session[:kan_firstname],
      kana_familyname: session[:kana_familyname],
      kana_firstname: session[:kana_firstname]
    )
  end

  def fifth
    # session[:kan_familyname] = user_info_params[:kan_familyname]
    # session[:kan_firstname] = user_info_params[:kan_firstname]
    # session[:kana_familyname] = user_info_params[:kana_familyname]
    # session[:kana_firstname] = user_info_params[:kana_firstname]
    # session[:post_number] = user_info_params[:post_number]
    # session[:prefecture] = user_info_params[:prefecture]
    # session[:city] = user_info_params[:city]
    # session[:address] = user_info_params[:address]
    # session[:building] = user_info_params[:building]
    @card = Card.new
  end

  def done
    Payjp.api_key = ENV['PAYJP_API_KEY']
    if params['payjp_token'].blank?
      render :done
    else  
      customer = Payjp::Customer.create(card: pay_params[:payjp_token])  #顧客作成
      Card.new(
        customer_id: customer.id,
        card_id: customer.default_card,
        user_id: user.id
      )
    end
  end

  def create    

    user_create
    sign_in User.find(@user.id) if @user.save


    save_to_session_user_info
    @user_info.user_id = current_user.id
    if @user_info.save
      redirect_to fifth_signups_path
    else
      render "forth"
    end


  end


  private

  def user_params
    params.require(:user).permit(
      :nickname, 
      :email, 
      :password, 
      :kan_familyname, 
      :kan_firstname, 
      :kana_familyname, 
      :kana_firstname, 
      :birthday,
      'birthday(1i)',
      'birthday(2i)',
      'birthday(3i)',
      :tel
    )
  end

  def user_info_params
    params.require(:user_info).permit(
      :kan_familyname, 
      :kan_firstname, 
      :kana_familyname, 
      :kana_firstname, 
      :post_number,
      :prefecture,
      :city,
      :address,
      :building
    )
  end

  def card_params
    params.permit(:payjp_token)
  end


  def user_create

    @user = User.new(
      nickname: session[:nickname],
      email: session[:email],
      password: session[:password],
      kan_familyname: session[:kan_familyname],
      kan_firstname: session[:kan_firstname],
      kana_familyname: session[:kana_familyname],
      kana_firstname: session[:kana_firstname],
      birthday: session[:birthday],
      tel: session[:tel]
    )
    render "first" unless @user.valid?
  
  end


  def save_to_session_user
    session[:nickname] = user_params[:nickname]
    session[:email] = user_params[:email]
    session[:password] = user_params[:password]
    session[:kan_familyname] = user_params[:kan_familyname]
    session[:kan_firstname] = user_params[:kan_firstname]
    session[:kana_familyname] = user_params[:kana_familyname]
    session[:kana_firstname] = user_params[:kana_firstname]
    session[:birthday] = user_params['birthday(1i)'] + "/" + user_params['birthday(2i)'] + "/" + user_params['birthday(3i)']
    session[:tel] = user_params[:tel]

    user_create
  end


  def save_to_session_user_info
    session[:kan_familyname] = user_info_params[:kan_familyname]
    session[:kan_firstname] = user_info_params[:kan_firstname]
    session[:kana_familyname] = user_info_params[:kana_familyname]
    session[:kana_firstname] = user_info_params[:kana_firstname]
    session[:post_number] = user_info_params[:post_number]
    session[:prefecture] = user_info_params[:prefecture]
    session[:city] = user_info_params[:city]
    session[:address] = user_info_params[:address]
    session[:building] = user_info_params[:building]

    @user_info = UserInfo.new(
      kan_familyname: session[:kan_familyname],
      kan_firstname: session[:kan_firstname],
      kana_familyname: session[:kana_familyname],
      kana_firstname: session[:kana_firstname],
      post_number: session[:post_number],
      prefecture: session[:prefecture],
      city: session[:city],
      address: session[:address],
      building: session[:building]
    )
  end

  def get_payjp_info
    Payjp.api_key = ENV['PAYJP_ACCESS_KEY']
  end


  def validates_first
    session[:nickname] = user_params[:nickname]
    session[:email] = user_params[:email]
    session[:password] = user_params[:password]
    session[:kan_familyname] = user_params[:kan_familyname]
    session[:kan_firstname] = user_params[:kan_firstname]
    session[:kana_familyname] = user_params[:kana_familyname]
    session[:kana_firstname] = user_params[:kana_firstname]
    session[:birthday] = user_params['birthday(1i)'] + "/" + user_params['birthday(2i)'] + "/" + user_params['birthday(3i)']
    # バリデーション用に、仮でインスタンスを作成する
    @user = User.new(
      nickname: session[:nickname], # sessionに保存された値をインスタンスに渡す
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password_confirmation],
      kan_familyname: session[:kan_familyname],
      kan_firstname: session[:kan_firstname],
      kana_familyname: session[:kana_familyname],
      kana_firstname: session[:kana_firstname],
      birthday: session[:birthday],
      tel: "08011112222"
    )
    # 仮で作成したインスタンスのバリデーションチェックを行う
  render 'first' unless @user.valid?
  # if @user.valid?
  #   redirect_to second_signups_path
  # else
  #   render "first"
  # end
  end


  def validates_second
    session[:tel] = user_params[:tel]
    # バリデーション用に、仮でインスタンスを作成する
    @user = User.new(
      nickname: session[:nickname], # sessionに保存された値をインスタンスに渡す
      email: session[:email],
      password: session[:password],
      password_confirmation: session[:password_confirmation],
      kan_familyname: session[:kan_familyname],
      kan_firstname: session[:kan_firstname],
      kana_familyname: session[:kana_familyname],
      kana_firstname: session[:kana_firstname],
      birthday: session[:birthday],
      tel: session[:tel]
    )
    # 仮で作成したインスタンスのバリデーションチェックを行う
  render 'second' unless @user.valid?
  # if @user.valid?
  #   redirect_to forth_signups_path
  # else
  #   render "second"
  # end
  end


  def validates_forth
    session[:kan_familyname] = user_info_params[:kan_familyname]
    session[:kan_firstname] = user_info_params[:kan_firstname]
    session[:kana_familyname] = user_info_params[:kana_familyname]
    session[:kana_firstname] = user_info_params[:kana_firstname]
    session[:post_number] = user_info_params[:post_number]
    session[:prefecture] = user_info_params[:prefecture]
    session[:city] = user_info_params[:city]
    session[:address] = user_info_params[:address]
    session[:building] = user_info_params[:building]
    # バリデーション用に、仮でインスタンスを作成する
    @user_info = UserInfo.new(
      kan_familyname: session[:kan_familyname],
      kan_firstname: session[:kan_firstname],
      kana_familyname: session[:kana_familyname],
      kana_firstname: session[:kana_firstname],
      post_number: session[:post_number],
      prefecture: session[:prefecture],
      city: session[:city],
      address: session[:address],
      building: session[:building]
    )
    # 仮で作成したインスタンスのバリデーションチェックを行う
  # render 'forth' unless @user_info.valid?

  if @user_info.valid?
    redirect_to fifth_signups_path
  else
    render "forth"
  end
  end

end