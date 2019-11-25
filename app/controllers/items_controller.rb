class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
  end
  def new
  end
  def create
  end
  
end
