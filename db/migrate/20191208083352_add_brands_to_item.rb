class AddBrandsToItem < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :brand, :string
    add_reference :items, :brand
  end
end
