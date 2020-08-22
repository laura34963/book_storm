class AddPasswordToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password, :string, default: 'default_pwd'
  end
end