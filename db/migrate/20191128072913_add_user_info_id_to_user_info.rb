class AddUserInfoIdToUserInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :user_infos, :user_info_id, :integer, foreign_key: true
  end
end
