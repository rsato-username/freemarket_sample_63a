class UsersController < ApplicationController

  def index
  end

  def logout
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
  end
  
end
