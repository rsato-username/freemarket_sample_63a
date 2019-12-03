class SignupsController < ApplicationController
  before_action :save_to_session_user, only: :second

  def index
  end

  def first
    @user = User.new
  end

  def second
    # binding.pry
    session[:nickname] = user_params[:nickname]
    session[:email] = user_params[:email]
    session[:password] = user_params[:password]
    session[:kan_familyname] = user_params[:kan_familyname]
    session[:kan_firstname] = user_params[:kan_firstname]
    session[:kana_familyname] = user_params[:kana_familyname]
    session[:kana_firstname] = user_params[:kana_firstname]
    session[:birthday] = user_params['birthday(1i)'] + "/" + user_params['birthday(2i)'] + "/" + user_params['birthday(3i)']

    @user = User.new
  end

  def third
  end

  def forth
    session[:tel] = user_params[:tel]
    @user_info = UserInfo.new
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


  def create    
    user_create
    # birthday_join
    # if @user.save
    #   # ログインするための情報を保管
    #   # session[:id] = @user.id
    #   redirect_to signups_path
    # else
    #   render 'first'
    # end
    sign_in User.find(@user.id) if @user.save


    save_to_session_user_info
    @user_info.user_id = current_user.id
    if @user_info.save
      redirect_to fifth_signups_path
    else
      render "forth"
    end


    # Card.create(card_params)
    # # save_to_session_card
    # @card = Card.new(
    #     number: card_params[:number],
    #     validity_year: card_params[:validity_year],
    #     validity_month: card_params[:validity_month],
    #     security_cord: card_params[:security_cord] 
    #   )
    # # @card.user_id = current_user.id
    # if @card.save
    #   redirect_to signups_path, method: :post
    # else
    #   render "fifth"
    # end

    # sign_in User.find(session[:id]) unless user_signed_in?

  end

  private
  # 許可するキーを設定します
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
    params.require(:card).permit(
      :number, 
      :validity_year, 
      :validity_month, 
      :security_cord
    )
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

    render "first" unless @user.valid?
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


  def save_to_session_card
    session[:number] = card_params[:number]
    session[:validity_year] = card_params[:validity_year]
    session[:validity_month] = card_params[:validity_month]
    session[:security_cord] = card_params[:security_cord]

    @card = Card.new(
      number: session[:number],
      validity_year: session[:validity_year],
      validity_month: session[:validity_month],
      security_cord: session[:security_cord]
    )
  end


end
