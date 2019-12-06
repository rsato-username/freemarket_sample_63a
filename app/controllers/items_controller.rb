class ItemsController < ApplicationController

  def index
  end

  def new
    @item = Item.new
    10.times{
      @item.photos.build
    }
    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent
    end
  end
  
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  def show
  end

  def pay
    Payjp.api_key = ENV['PAYJP_ACCESS_KEY']
    card = current_user.cards.first
    if card.blank?
      redirect_to pay_cards_path
    else
      @item = Item.find(params[:id])
      Payjp::Charge.create(
        amount: @item.price,
        customer: card.customer_id,
        currency: 'jpy',
      )
    end
    redirect_to items_path
  end
  
  private
  def item_params
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :brand, :category_id, :user_id, photos_attributes:[:url]).merge(user_id: current_user.id)
  end
end
