class AddDetailsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :kan_familyname, :string, null: false
    add_column :users, :kan_firstname, :string, null: false
    add_column :users, :kana_familyname, :string, null: false
    add_column :users, :kana_firstname, :string, null: false
    add_column :users, :birthday, :integer
  end
end
