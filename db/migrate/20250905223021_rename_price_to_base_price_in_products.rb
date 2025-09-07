class RenamePriceToBasePriceInProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :products, :price, :base_price
  end
end
