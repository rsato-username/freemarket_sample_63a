class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.integer :number, null: false
      t.integer :validity_year, null: false
      t.integer :validity_month, null: false
      t.integer :security_cord, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
