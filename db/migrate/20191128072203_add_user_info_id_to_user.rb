class AddUserInfoIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_info_id, :integer, foreign_key: true
  end
end
