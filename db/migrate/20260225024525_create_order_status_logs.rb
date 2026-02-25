class CreateOrderStatusLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :order_status_logs do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :from_status
      t.integer :to_status, null: false
      t.string :changed_by
      t.text :note

      t.datetime :created_at, null: false
    end
  end
end
