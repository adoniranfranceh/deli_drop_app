class CreateModifierGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :modifier_groups do |t|
      t.string :name
      t.integer :input_type
      t.integer :min
      t.integer :max
      t.integer :free_limit
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
