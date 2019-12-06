class ItemsController < ApplicationController

  def index
  end

  def new
  end
  
  def create
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
  
end
