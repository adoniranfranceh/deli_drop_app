class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, foreign_key: true

      # Snapshot data
      t.string :product_name, null: false
      t.string :product_image
      t.integer :unit_price, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :total_price, null: false
      t.text :comment

      t.timestamps
    end
  end
end
