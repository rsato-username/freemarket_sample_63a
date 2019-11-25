class ItemsController < ApplicationController
  before_filter :authenticate_user!, except: :index


  def index
  end
  def new
  end
  def create
  end
  
end
