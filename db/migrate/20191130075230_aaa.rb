class Aaa < ActiveRecord::Migration[5.2]
  def change
    drop_table :cards
    drop_table :user_infos
  end
end
