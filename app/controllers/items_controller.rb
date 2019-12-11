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
    @item.photos.build
    
    
    # 10.times{
    #   @item.photos.build
    # }
    @parents = Category.all.order("id ASC").limit(13)

    gon.item = @item
    gon.item_images = @item.photos

    # @item.item_imagse.image_urlをバイナリーデータにしてビューで表示できるようにする
    # require 'base64'
    # require 'aws-sdk'
    # require 'carrierwave/storage/abstract'
    # require 'carrierwave/storage/file'
    # require 'carrierwave/storage/fog'

    gon.item_images_binary_datas = []
    # if Rails.env.production?
    #   client = Aws::S3::Client.new(
    #                          region: 'ap-northeast-1',
    #                          aws_access_key_id: Rails.application.secrets.aws_access_key_id,
    #                          aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    #                          )
    #   @item.photos.each do |image|
    #     binary_data = client.get_object(bucket: 'free-buckeeet', key: photos.url.url).body.read
    #     gon.item_images_binary_datas << Base64.strict_encode64(binary_data)
    #   end
    # else
    #   @item.photos.each do |image|
    #     binary_data = File.read(image.url.url)
    #     gon.item_images_binary_datas << Base64.strict_encode64(binary_data)
    #   end
    # end
  end


  def update



    if  brand = Brand.find_by(name: params[:item][:brand_id])
      params[:item][:brand_id] = brand.id
    else
      params[:item][:brand_id] = Brand.create(name: params[:item][:brand_id]).id
    end

    @item = Item.find(params[:id])

    # 登録済画像のidの配列を生成
    ids = @item.photos.map{|image| photo.id }
    # 登録済画像のうち、編集後もまだ残っている画像のidの配列を生成(文字列から数値に変換)
    exist_ids = registered_image_params[:ids].map(&:to_i)
    # 登録済画像が残っていない場合(配列に０が格納されている)、配列を空にする
    exist_ids.clear if exist_ids[0] == 0

    if (exist_ids.length != 0 || new_image_params[:images][0] != " ") && @item.update(item_params)

      # 登録済画像のうち削除ボタンをおした画像を削除
      unless ids.length == exist_ids.length
        # 削除する画像のidの配列を生成
        delete_ids = ids - exist_ids
        delete_ids.each do |id|
          @item.photos.find(id).destroy
        end
      end

      # 新規登録画像があればcreate
      unless new_image_params[:photos][0] == " "
        params[:photos][:url].each do |url|
          @item.photos.create(url: url, item_id: @item.id)
        end
      end

      flash[:notice] = '編集が完了しました'
      redirect_to item_path(@item), data: {turbolinks: false}

    else
      flash[:alert] = '未入力項目があります'
      redirect_back(fallback_location: root_path)
    end




    # @item = Item.find(params[:id])

    # respond_to do |format|
    #   if @item.save
    #     params[:photos][:url].each do |url|
    #       @item.photos.create(url: url, item_id: @item.id)
    #     end
    #     format.html{redirect_to item_path(@item)}
    #   else
    #     @item.photos.build
    #     format.html{render action: 'edit'}
    #   end
    # end


    # if @item.update(item_update_params)
    #   redirect_to profile_users_path
    # else
    #   render :edit
    # end
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
    params.require(:item).permit(:name, :price, :description, :status, :post_money, :post_region, :post_day, :brand, :category_id, :user_id, photos_attributes:[:url, :id]).merge(user_id: current_user.id)
  end
  
  def photo_params
    params.require(:item).permit({photos_attributes:[]})
  end



  def registered_image_params
    params.require(:registered_images_ids).permit({ids: []})
  end

  def new_image_params
    params.require(:new_images).permit({images: []})
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
