class CreateBusinessHours < ActiveRecord::Migration[6.0]
  def change
    create_table :business_hours do |t|
      t.integer :store_id
      t.integer :opentime
      t.integer :closetime

      t.timestamps
    end

    remove_column :stores, :opentime
    change_column_default :users, :balance, 0
    change_column_default :stores, :balance, 0
    change_column_default :books, :price, 0
  end
end
