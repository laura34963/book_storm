class CreatePurchaseHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :purchase_histories do |t|
      t.integer :store_id
      t.integer :book_id
      t.integer :user_id
      t.decimal :amount
      t.datetime :date

      t.timestamps
    end
  end
end
