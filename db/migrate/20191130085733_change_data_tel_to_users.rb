class ChangeDataTelToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :tel, :bigint
  end
end
