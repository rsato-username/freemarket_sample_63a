class CreateUserInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :user_infos do |t|
      t.string :kan_familyname, null: false
      t.string :kan_firstname, null: false
      t.string :kana_familyname, null: false
      t.string :kana_firstname, null: false
      t.integer :birthday
      t.integer :post_number, null: false
      t.string :prefecture, null: false
      t.string :city, null: false
      t.string :address, null: false
      t.string :building
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
