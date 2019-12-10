class ItemsController < ApplicationController

  def index
    # @parent_categories = Category.roots

    # ladies = Category.find_by(name: "レディース").subtree
    @ladies_items = Item.where(category_id: 1).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @mens_items = Item.where(category_id: 2).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @kadens_items = Item.where(category_id: 8).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @toys_items = Item.where(category_id: 6).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
  end

  def new
    @item = Item.new
    @item.photos.build
    @parents = Category.all.order("id ASC").limit(13)
  end

  def create
    @item = Item.new(item_params)
    @parents = Category.all.order("id ASC").limit(13)
    # params[:item][:photos_attributes]["0"][:url].each do |photo|
    #   @item.photos.build
    #   num = 0
    #   params[:item][:photos_attributes]["0"][:url][num] = photo
    #   num += 1
    # end
    binding.pry

    # params[:item][:photos_attributes]["0"][:url][0].original_filename
    
    if @item.save
      redirect_to root_path, notice: '出品しました。'
    else
      render :new
    end

    # params[:photos_attributes]['url'].each do |a|
    #   @item_image = @product.item_images.create!(name: a)
    # end

    # a = item_params[photos_attributes: {url: []}]
    # a.each do |photo|
    #   new_photo = Photo.new(url: photo)
    #   new_photo.save
    # end

    # if @item.save
    #   redirect_to root_path
    # else
    #   render :new
    # end

  end

  def show
    @item = Item.find(params[:id])
    @items = Item.all.limit(10).order("created_at DESC").includes(:user)
    
    # @items = Item.includes(:user).where("#{User.ids}").limit(10).order("created_at DESC")
    @ladies_items = Item.where(category_id: 1).limit(10).order("created_at DESC").includes(:photos)
    @mens_items = Item.where(category_id: 2).limit(10).order("created_at DESC").includes(:photos)
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
    @item.update( buyer_id: current_user.id)
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

  def search
    # @item = Item.where(name: true).search(params[:search])
    @item = Item.search(params[:name]).limit(132)
    @search = params[:name]
    # if params[:search]
    #   @search = Item.where(['name LIKE ?', "%#{search}%"])
    # else
    #   @search = Item.all
    # end
  end

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
  
  private
  def item_params
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :brand, :category_id, :user_id, photos_attributes: {url: []}).merge(user_id: current_user.id)
  end
end
