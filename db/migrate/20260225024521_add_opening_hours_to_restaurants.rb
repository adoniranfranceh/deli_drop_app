class AddOpeningHoursToRestaurants < ActiveRecord::Migration[8.0]
  def change
    add_column :restaurants, :opening_time, :time
    add_column :restaurants, :closing_time, :time
    add_column :restaurants, :open_days, :integer, default: [], array: true
  end
end
