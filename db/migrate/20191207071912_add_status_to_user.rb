class AddStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :status, :string
    add_column :users, :buyer_id, :integer
  end
end
