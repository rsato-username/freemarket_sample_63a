class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table   :items do |t|
      t.string     :name,        null: false
      t.integer    :price,       null: false
      t.text       :description, null: false
      t.string     :status,      null: false
      t.string     :brand
      t.string     :post_money,  null: false
      t.string     :post_region, null: false
      t.string     :post_day,    null: false
      t.references    :user,     null: false, foreign_key: true
      t.references    :category, null: false, foreign_key: true
      t.timestamps
    end
  end
end