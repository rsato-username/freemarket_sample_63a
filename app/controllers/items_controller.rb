class ItemsController < ApplicationController

  def index
  end

  def new
    @item = Item.new
  end
  
  def create
    Item.create(item_params)
    redirect_to root_path
  end
  
  private
  def item_params
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :user_id, :category_id, :brand_id)
  end
end
