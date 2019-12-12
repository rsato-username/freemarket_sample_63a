class UsersController < ApplicationController

  def index
    @items = Item.where(situation: "取引中").limit(5).order("created_at DESC")
    @buy_items = Item.where(buyer_id: current_user.id).limit(5).order("created_at DESC")
  end

  def logout
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
  end

  def myitem
    @item = Item.where(user_id: current_user.id)
    @itemNow = Item.where(user_id: current_user.id).where(buyer_id: nil)
    @itemSelled = Item.where(user_id: current_user.id).where.not(buyer_id: nil)
  end
  
end
