class AddStatusToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :situation, :string
    add_column :items, :buyer_id, :integer
  end
end
