class SignupsController < ApplicationController

  def index

  end
  def first
    @user = User.new
  end

  def second
    
  end

  def third
    
  end

  def forth
    
  end

  def fifth
    
  end


  private
  # def user_params
  #   params.require(:user).permit(:nickname, :email, :password).merge(user_id: current_user.id)
  # end

  def first_params
    # params.require(:user_info).permit(:kan_familyname,
    #                                   :kan_familyname,
    #                                   :kana_familyname,
    #                                   :kana_firstname,
    #                                   :birthday).merge(user_id: current_user.id)
  end
end
