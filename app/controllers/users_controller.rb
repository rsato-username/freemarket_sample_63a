class UsersController < ApplicationController

  def index
  end

  def logout
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
  end

  def myitem
    @item = Item.where(user_id: current_user.id).where()
    @itemNow = Item.where(user_id: current_user.id).where(buyer_id: nil)
    @itemSelled = Item.where(user_id: current_user.id).where.not(buyer_id: nil)
  end
  
end
