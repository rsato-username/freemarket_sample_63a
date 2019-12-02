class Cards < ActiveRecord::Migration[5.2]
  def change
    remove_column :cards, :number, :integer
    remove_column :cards, :validity_year, :integer
    remove_column :cards, :validity_month, :integer
    remove_column :cards, :security_cord, :integer
    add_column :cards, :customer_id, :string, null: false
    add_column :cards, :card_id, :string, null: false
  end
end