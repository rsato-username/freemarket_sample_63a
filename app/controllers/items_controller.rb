class ItemsController < ApplicationController

  def index
    # @parent_categories = Category.roots
    @parents = Category.all.order("id ASC").limit(13)

    # ladies = Category.find_by(name: "レディース").subtree
    @ladies_items = Item.where(category_id: 1).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @mens_items = Item.where(category_id: 2).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @kadens_items = Item.where(category_id: 8).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @toys_items = Item.where(category_id: 6).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @chanels_items = Item.joins(:brand).where(brands: {name: "シャネル"}).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @vuittons_items = Item.joins(:brand).where(brands: {name: "ルイヴィトン"}).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @sups_items = Item.joins(:brand).where(brands: {name: "シュプリーム"}).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)
    @nikes_items = Item.joins(:brand).where(brands: {name: "ナイキ"}).limit(10).order("created_at DESC").includes(:photos).where(situation: nil)

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
    @item.build_brand
    @parents = Category.all.order("id ASC").limit(13)

  end
  
  def create
    @item = Item.new(item_params)
    @parents = Category.all.order("id ASC").limit(13)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
    
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

  def edit

    @item = Item.find(params[:id])
    # picture = 10
    # count = @item.photos.count
    # @item.photos.build
    10.times{
      @item.photos.build
    }
    @parents = Category.all.order("id ASC").limit(13)
  end


  def update
    @item = Item.find(params[:id])


    # ids = @item.photos.map{|photos| photos.id }
    # # 登録済画像のうち、編集後もまだ残っている画像のidの配列を生成(文字列から数値に変換)
    # exist_ids = registered_photo_params[:ids]
    # # 登録済画像が残っていない場合(配列に０が格納されている)、配列を空にする
    # # exist_ids.clear if exist_ids[0] == 0

    # if (exist_ids != 0 || new_photo_params[:photos_attributes][0] != " ") && @item.update(item_params)

    #   # 登録済画像のうち削除ボタンをおした画像を削除
    #   unless ids.length == exist_ids.length
    #     # 削除する画像のidの配列を生成
    #     delete_ids = ids - exist_ids
    #     delete_ids.each do |id|
    #       @item.photos.find(id).destroy
    #     end
    #   end

    #   # 新規登録画像があればcreate
    #   unless new_photo_params[:photos][0] == " "
    #     new_photo_params[:photos].each do |image|
    #       @item.photos.create(url: image, id: @item.id)
    #     end
    #   end

    #   flash[:notice] = '編集が完了しました'
    #   redirect_to item_path(@item), data: {turbolinks: false}
    # end
    
    # # 選択されたファイルを削除
    # remove_image_at_index(params[:photos][:url])
   
    # unless @item.save
    #   flash[:alert] = '変更に失敗しました'
    #   redirect_back(fallback_location: root_path)
    # end
  
    # # 画像の追加
    # add_image(params[:item][:photos_attributes], params[:photos][:url])
  
    # unless @item.save
    #   flash[:alert] = '変更に失敗しました'
    #   redirect_back(fallback_location: root_path)
    # end
    
    # flash[:notice] = '画像を変更しました'
    # redirect_back(fallback_location: root_path)

    # @item.photos.remove_url
    # @item.photos.save

    if @item.update(item_update_params)
      redirect_to profile_users_path
    else
      render :edit
    end
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
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :category_id, :user_id, brand_attributes:[:id, :name], photos_attributes:[:url]).merge(user_id: current_user.id)
  end

  def item_update_params
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :brand, :category_id, :user_id, photos_attributes:[:id, :url, :remove_url, :url_cache]).merge(user_id: current_user.id)
  end

  # def item_update_params
  #   params.require(:item).permit(photos_attributes:[:id, :url, :remove_url, :url_cache]).merge(user_id: current_user.id)
  # end

#   def item_update_params
#     params.require(:item).permit(photos_attributes:[:id, :url, :remove_url, :url_cache]).merge(user_id: current_user.id)
# end


  # def remove_image_at_index(index)
  #   remain_images = @item.photos # 画像の配列をコピーする
  #   deleted_image = remain_images.delete(index) #指定した画像を削除
  #   deleted_image.try(:remove!) # S3から削除する場合追加
  #   @item.photos = remain_images # 代入し直す
  # end

  # def add_image(new_image, index)
  #   images = @item.photos # 画像の配列をコピーする
  #   images.insert(new_image, index) # 画像を削除した位置に挿入
  #   @item.photos = images # 代入し直す
  # end

  # def registered_photo_params
  #   params.require(:item).permit({photos_attributes: []})
  # end

  # def new_photo_params
  #   params.require(:item).permit({photos_attributes: []})
  # end
end
