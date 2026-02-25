class CreateOrderItemModifiers < ActiveRecord::Migration[8.0]
  def change
    create_table :order_item_modifiers do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :modifier, foreign_key: true

      # Snapshot data
      t.string :group_name, null: false
      t.string :modifier_name, null: false
      t.integer :unit_price, null: false
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
