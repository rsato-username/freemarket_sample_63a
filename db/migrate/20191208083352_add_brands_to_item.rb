class AddBrandsToItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :brand
  end
end
