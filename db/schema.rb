# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_25_024525) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "restaurant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_categories_on_restaurant_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["phone"], name: "index_customers_on_phone", unique: true
  end

  create_table "modifier_groups", force: :cascade do |t|
    t.string "name"
    t.integer "input_type"
    t.integer "min"
    t.integer "max"
    t.integer "free_limit"
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_modifier_groups_on_product_id"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string "name"
    t.integer "base_price"
    t.string "image"
    t.bigint "modifier_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modifier_group_id"], name: "index_modifiers_on_modifier_group_id"
  end

  create_table "order_item_modifiers", force: :cascade do |t|
    t.bigint "order_item_id", null: false
    t.bigint "modifier_id"
    t.string "group_name", null: false
    t.string "modifier_name", null: false
    t.integer "unit_price", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modifier_id"], name: "index_order_item_modifiers_on_modifier_id"
    t.index ["order_item_id"], name: "index_order_item_modifiers_on_order_item_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id"
    t.string "product_name", null: false
    t.string "product_image"
    t.integer "unit_price", null: false
    t.integer "quantity", default: 1, null: false
    t.integer "total_price", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "order_status_logs", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "from_status"
    t.integer "to_status", null: false
    t.string "changed_by"
    t.text "note"
    t.datetime "created_at", null: false
    t.index ["order_id"], name: "index_order_status_logs_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "code", null: false
    t.integer "status", default: 0, null: false
    t.bigint "restaurant_id", null: false
    t.bigint "customer_id", null: false
    t.string "delivery_address", null: false
    t.string "delivery_complement"
    t.string "delivery_neighborhood"
    t.string "delivery_reference"
    t.integer "subtotal", null: false
    t.integer "delivery_fee", default: 0, null: false
    t.integer "discount", default: 0, null: false
    t.integer "total", null: false
    t.integer "payment_method", null: false
    t.integer "change_for"
    t.integer "payment_status", default: 0, null: false
    t.text "customer_note"
    t.text "rejection_reason"
    t.text "cancellation_reason"
    t.integer "estimated_delivery_time"
    t.datetime "expires_at"
    t.datetime "confirmed_at"
    t.datetime "preparing_at"
    t.datetime "ready_at"
    t.datetime "out_for_delivery_at"
    t.datetime "delivered_at"
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_orders_on_code", unique: true
    t.index ["created_at"], name: "index_orders_on_created_at"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["restaurant_id", "status"], name: "index_orders_on_restaurant_id_and_status"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.integer "base_price"
    t.text "description"
    t.string "ingredients", default: [], array: true
    t.integer "status"
    t.boolean "featured"
    t.bigint "restaurant_id", null: false
    t.integer "duration"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["restaurant_id"], name: "index_products_on_restaurant_id"
  end

  create_table "restaurant_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_restaurant_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_restaurant_users_on_reset_password_token", unique: true
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.integer "culinary_style"
    t.text "description"
    t.string "image"
    t.string "phone"
    t.string "address"
    t.bigint "restaurant_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "opening_time"
    t.time "closing_time"
    t.integer "open_days", default: [], array: true
    t.index ["restaurant_user_id"], name: "index_restaurants_on_restaurant_user_id"
  end

  add_foreign_key "categories", "restaurants"
  add_foreign_key "modifier_groups", "products"
  add_foreign_key "modifiers", "modifier_groups"
  add_foreign_key "order_item_modifiers", "modifiers"
  add_foreign_key "order_item_modifiers", "order_items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "order_status_logs", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "restaurants"
  add_foreign_key "restaurants", "restaurant_users"
end
