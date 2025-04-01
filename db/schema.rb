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

ActiveRecord::Schema[7.2].define(version: 2025_04_01_163205) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "order_status", ["pending", "ordered"]
  create_enum "product_category", ["clothing", "electronics", "books", "beauty"]

  create_table "orders", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "units", null: false
    t.decimal "unit_price", null: false
    t.datetime "expiration_date"
    t.datetime "order_date"
    t.enum "status", null: false, enum_type: "order_status"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_orders_on_created_by_id"
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["updated_by_id"], name: "index_orders_on_updated_by_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 10, null: false
    t.text "description"
    t.enum "category", null: false, enum_type: "product_category"
    t.decimal "price", null: false
    t.integer "units", default: 0
    t.string "images", default: [], array: true
    t.integer "users_score"
    t.integer "sold_units", default: 0
    t.string "location"
    t.decimal "real_price"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.index ["code"], name: "index_products_on_code", unique: true
    t.index ["created_by_id"], name: "index_products_on_created_by_id"
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
    t.index ["updated_by_id"], name: "index_products_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "name"
    t.boolean "is_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
