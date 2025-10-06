class CreateModifiers < ActiveRecord::Migration[8.0]
  def change
    create_table :modifiers do |t|
      t.string :name
      t.integer :base_price
      t.string :image
      t.references :modifier_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
