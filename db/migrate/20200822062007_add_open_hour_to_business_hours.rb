class AddOpenHourToBusinessHours < ActiveRecord::Migration[6.0]
  def change
    add_column :business_hours, :open_hour, :float, default: 0
  end
end
