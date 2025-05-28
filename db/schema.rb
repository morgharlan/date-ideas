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

ActiveRecord::Schema[7.1].define(version: 2025_05_28_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "date_ideas", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.decimal "budget", precision: 8, scale: 2
    t.string "time_of_day"
    t.string "setting"
    t.string "effort"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "detailed_plan"
  end

  create_table "saved_dates", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "date_idea_id", null: false
    t.text "note"
    t.boolean "favorite", default: false
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_idea_id"], name: "index_saved_dates_on_date_idea_id"
    t.index ["user_id", "date_idea_id"], name: "index_saved_dates_on_user_id_and_date_idea_id", unique: true
    t.index ["user_id"], name: "index_saved_dates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "saved_dates", "date_ideas"
  add_foreign_key "saved_dates", "users"
end
