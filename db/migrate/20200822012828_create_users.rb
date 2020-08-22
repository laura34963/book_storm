class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :store_id
      t.string :name
      t.decimal :balance

      t.timestamps
    end
  end
end
