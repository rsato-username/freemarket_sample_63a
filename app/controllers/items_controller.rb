class ItemsController < ApplicationController

  def index
    # @parent_categories = Category.roots

    # ladies = Category.find_by(name: "レディース").subtree
    @ladies_items = Item.where(category_id: 1).limit(10).order("created_at DESC").includes(:photos)
    @mens_items = Item.where(category_id: 2).limit(10).order("created_at DESC").includes(:photos)
    @kadens_items = Item.where(category_id: 8).limit(10).order("created_at DESC").includes(:photos)
    @toys_items = Item.where(category_id: 6).limit(10).order("created_at DESC").includes(:photos)
  end

  def new
    @item = Item.new
    10.times{
      @item.photos.build
    }
    # @category_parent_array = ["---"]
    # Category.where(ancestry: nil).each do |parent|
    #   @category_parent_array << parent
    # end

    @parents = Category.all.order("id ASC").limit(13)

  end
  
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
    @ladies_items = Item.where(category_id: 1).limit(10).order("created_at DESC").includes(:photos)
    @mens_items = Item.where(category_id: 2).limit(10).order("created_at DESC").includes(:photos)
  end

  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    # @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
    @category_children = Category.find(params[:parent_name]).children
  end

  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    # @category_grandchildren = Category.find("#{params[:child_id]}").children
    @category_grandchildren = Category.find(params[:child_id]).children
  end

  def buy
    @item = Item.find(params[:id])
    Payjp.api_key = ENV['PAYJP_ACCESS_KEY']
    card = current_user.card.first
    if card.present?
      customer = Payjp::Customer.retrieve(card.customer_id)
      @card_info = customer.cards.retrieve(card.card_id)
    else
      redirect_to action: :confirmation, id: current_user.id
    end
  end

  def pay
    Payjp.api_key = ENV['PAYJP_ACCESS_KEY']
    card = current_user.card.first
    if card.blank?
      redirect_to confirmation_card_path
    else
      @item = Item.find(params[:id])
      Payjp::Charge.create(
        amount: @item.price,
        customer: card.customer_id,
        currency: 'jpy',
      )
    end
    redirect_to purchash_item_path
  end

  def purchash
    Payjp.api_key = ENV['PAYJP_ACCESS_KEY']
    @item = Item.find(params[:id])
    card = current_user.card.first
    if card.present?
      customer = Payjp::Customer.retrieve(card.customer_id)
      @card_info = customer.cards.retrieve(card.card_id)
    else
      redirect_to action: :confirmation, id: current_user.id
    end
  end
  
  private
  def item_params
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :brand, :category_id, :user_id, photos_attributes:[:url]).merge(user_id: current_user.id)
  end
end
