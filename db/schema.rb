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

ActiveRecord::Schema[7.0].define(version: 2023_09_15_201726) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "roast", default: 0, null: false
    t.integer "fineness", default: 0, null: false
    t.bigint "region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_beans_on_region_id"
  end

  create_table "brewing_methods", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brewing_methods_on_name", unique: true
  end

  create_table "dealers", force: :cascade do |t|
    t.bigint "bean_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bean_id", "shop_id"], name: "index_dealers_on_bean_id_and_shop_id", unique: true
    t.index ["bean_id"], name: "index_dealers_on_bean_id"
    t.index ["shop_id"], name: "index_dealers_on_shop_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "store_roast_option", default: 0, null: false
    t.integer "store_grind_option", default: 0, null: false
    t.date "purchase_at", null: false
    t.bigint "user_id", null: false
    t.bigint "bean_id", null: false
    t.bigint "shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bean_id"], name: "index_purchases_on_bean_id"
    t.index ["shop_id"], name: "index_purchases_on_shop_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title", null: false
    t.integer "fineness", default: 0, null: false
    t.integer "evaluation", null: false
    t.text "content"
    t.bigint "brewing_method_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "purchase_id"
    t.index ["brewing_method_id"], name: "index_reviews_on_brewing_method_id"
    t.index ["purchase_id"], name: "index_reviews_on_purchase_id", unique: true
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.integer "telephone_number"
    t.string "adress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_shops_on_name", unique: true
  end

  create_table "tools", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tools_on_name", unique: true
  end

  create_table "user_tools", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tool_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tool_id"], name: "index_user_tools_on_tool_id"
    t.index ["user_id", "tool_id"], name: "index_user_tools_on_user_id_and_tool_id", unique: true
    t.index ["user_id"], name: "index_user_tools_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "beans", "regions"
  add_foreign_key "dealers", "beans"
  add_foreign_key "dealers", "shops"
  add_foreign_key "purchases", "beans"
  add_foreign_key "purchases", "shops"
  add_foreign_key "purchases", "users"
  add_foreign_key "reviews", "brewing_methods"
  add_foreign_key "reviews", "purchases"
  add_foreign_key "user_tools", "tools"
  add_foreign_key "user_tools", "users"
end
