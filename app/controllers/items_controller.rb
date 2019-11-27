class ItemsController < ApplicationController

  def index
    @parents = Category.all
  end

  def new
  end
  
  def create
  end
  
end
