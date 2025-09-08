class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.integer :price
      t.text :description
      t.string :ingredients, array: true, default: []
      t.integer :status
      t.boolean :featured
      t.references :restaurant, null: false, foreign_key: true
      t.integer :duration
      t.string :image

      t.timestamps
    end
  end
end
