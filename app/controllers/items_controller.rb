class ItemsController < ApplicationController

  require 'payjp'
  before_action :get_payjp_info, only: [:buy, :pay, :purchash]

  def index
    # @parent_categories = Category.roots

    # ladies = Category.find_by(name: "レディース").subtree
    @ladies_items = Item.where(category_id: 1).limit(10).order("created_at DESC").where(situation: nil)
    @mens_items = Item.where(category_id: 2).limit(10).order("created_at DESC").where(situation: nil)
    @kadens_items = Item.where(category_id: 8).limit(10).order("created_at DESC").where(situation: nil)
    @toys_items = Item.where(category_id: 6).limit(10).order("created_at DESC").where(situation: nil)
    @chanels_items = Item.joins(:brand).where(brands: {name: "シャネル"}).limit(10).order("created_at DESC").where(situation: nil)
    @vuittons_items = Item.joins(:brand).where(brands: {name: "ルイヴィトン"}).limit(10).order("created_at DESC").where(situation: nil)
    @sups_items = Item.joins(:brand).where(brands: {name: "シュプリーム"}).limit(10).order("created_at DESC").where(situation: nil)
    @nikes_items = Item.joins(:brand).where(brands: {name: "ナイキ"}).limit(10).order("created_at DESC").where(situation: nil)

  end

  def new
    @item = Item.new
    @item.build_brand
    @parents = Category.all.order("id ASC").limit(13)
  end

  def create
    @item = Item.new(item_params)
    @parents = Category.all.order("id ASC").limit(13)
    
    if @item.save
      redirect_to root_path, notice: '出品しました。'
    else
      render :new
    end

  end

  def show
    @item = Item.find(params[:id])
    @items = Item.all.limit(10).order("created_at DESC").includes(:user).where(situation: nil)
    
    @ladies_items = Item.where(category_id: 1).limit(10).order("created_at DESC").where(situation: nil)
    @mens_items = Item.where(category_id: 2).limit(10).order("created_at DESC").where(situation: nil)
  end

  def edit
    @item = Item.find(params[:id])
    @parents = Category.all.order("id ASC").limit(13)
    
  end

  def update
    @item = Item.find(params[:id])
    @parents = Category.all.order("id ASC").limit(13)
    if @item.update(item_params)
      redirect_to item_path
    else
      render :show
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to root_path
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
    card = current_user.card.first
    if card.present?
      customer = Payjp::Customer.retrieve(card.customer_id)
      @card_info = customer.cards.retrieve(card.card_id)
    else
      redirect_to action: :confirmation, id: current_user.id
    end
  end

  def pay
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
    @item.update( buyer_id: current_user.id)
    redirect_to purchash_item_path
  end

  def purchash
    @item = Item.find(params[:id])
    card = current_user.card.first
    if card.present?
      customer = Payjp::Customer.retrieve(card.customer_id)
      @card_info = customer.cards.retrieve(card.card_id)
    else
      redirect_to action: :confirmation, id: current_user.id
    end
  end

  def search
    @item = Item.search(params[:name]).limit(132).where(situation: nil)
    @search = params[:name]
  end

  def categorylist
    @item = Item.categorysearch(params[:category_id]).limit(132).order("created_at DESC").where(situation: nil)
    @list = Category.find(params[:category_id])
  end

  # def brandlist
  #   @item = Item.brandsearch(params[:brand_id]).limit(132).order("created_at DESC").where(situation: nil)
  #   # @list = Brand.where(name: params[:brand_id])
  #   @list = Item.joins(:brand).brandsearch(params[:brand_id])
  #   # @list = Brand.find(params[:brand_id])
  # end

  def stopExhibit
    @item = Item.find(params[:id])
    @item.update(situation: "出品停止中")
    redirect_to item_path
  end

  def resumeExhibit
    @item = Item.find(params[:id])
    @item.update(situation: nil)
    redirect_to item_path
  end

  # def delete_image_attachment
  #   @image = ActiveStorage::Blob.find_signed(params[:id])
  #   @image.purge
  #   render :edit
  # end
  
  private
  def item_params
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :brand, :category_id, :user_id, brand_attributes:[:id, :name], images: []).merge(user_id: current_user.id)
  end

  def get_payjp_info
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_ACCESS_KEY)
  end

end
