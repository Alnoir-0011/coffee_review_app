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

ActiveRecord::Schema[7.0].define(version: 2023_09_14_125629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "roast", default: 0, null: false
    t.integer "fineness", default: 0, null: false
    t.bigint "regions_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["regions_id"], name: "index_beans_on_regions_id"
  end

  create_table "brewing_methods", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brewing_methods_on_name", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.integer "telephone_number"
    t.string "adress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_shops_on_name", unique: true
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

  add_foreign_key "beans", "regions", column: "regions_id"
end
