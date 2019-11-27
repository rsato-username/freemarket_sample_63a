class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string   :name,        null: false
      t.integer  :price,       null: false
      t.text     :description, null: false
      t.integer  :status,      null: false
      t.string   :post_money,  null: false
      t.string   :post_region, null: false
      t.string   :post_day,    null: false
      t.integer  :user_id,     null: false, foreign_key: true
      t.integer  :category_id, null: false, foreign_key: true
      t.integer  :brand_id,    null: false, foreign_key: true
      t.timestamps
    end
  end
end