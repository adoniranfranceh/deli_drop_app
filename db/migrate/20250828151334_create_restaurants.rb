class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.integer :culinary_style
      t.text :description
      t.string :image
      t.string :phone
      t.string :address
      t.references :restaurant_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
