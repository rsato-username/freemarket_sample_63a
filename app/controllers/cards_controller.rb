class CardsController < ApplicationController

  require 'payjp'
  before_action :get_payjp_info, only: [:create, :delete, :show]

  def new
    
  end

  def create
    if params['payjp-token'].blank?
      redirect_to action: :new, id: current_user.id
    else
      customer = Payjp::Customer.create(
      email: current_user.email,
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        if request.referer.include?('fifth')
          redirect_to controller: :signups, action: :done
        else
          redirect_to action: :show
        end
      else
        render action: :new, id: current_user.id
      end
    end
  end

  def delete
    card = current_user.card.first
    if card.present?
      customer = Payjp::Customer.retrieve(card.customer_id)
      customer.delete
      card.delete
    end
      redirect_to action: :confirmation, id: current_user.id
  end

  def show
    card = current_user.card.first
    # card = Card.where(user_id: current_user.id).first
    if card.present?
      customer = Payjp::Customer.retrieve(card.customer_id)
      @card_info = customer.cards.retrieve(card.card_id)
    else
      redirect_to action: :confirmation, id: current_user.id
    end
  end

  def confirmation
    card = current_user.card
    redirect_to action: :show if card.exists?
  end

  private

  def get_payjp_info
    Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_ACCESS_KEY)
  end

end
