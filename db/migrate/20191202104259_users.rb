class Users < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :birthday, :integer
    add_column :users, :birthday, :date
  end
end
