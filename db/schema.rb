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

ActiveRecord::Schema[8.0].define(version: 2025_04_17_201113) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "dismissed_keywords", force: :cascade do |t|
    t.string "word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["word"], name: "index_dismissed_keywords_on_word", unique: true
  end

  create_table "event_hosts", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_hosts_on_event_id"
    t.index ["user_id"], name: "index_event_hosts_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "date"
    t.string "location"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pies_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "physical"
    t.text "physical_description"
    t.integer "intellectual"
    t.text "intellectual_description"
    t.integer "emotional"
    t.text "emotional_description"
    t.integer "spiritual"
    t.text "spiritual_description"
    t.date "checked_in_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pies_entries_on_user_id"
  end

  create_table "reflection_tips", force: :cascade do |t|
    t.string "word"
    t.string "category"
    t.text "tip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_assignments", force: :cascade do |t|
    t.bigint "leader_id", null: false
    t.bigint "individual_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["individual_id"], name: "index_team_assignments_on_individual_id"
    t.index ["leader_id"], name: "index_team_assignments_on_leader_id"
  end

  create_table "unmatched_keywords", force: :cascade do |t|
    t.string "word"
    t.string "category"
    t.integer "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "example"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_foreign_key "event_hosts", "events"
  add_foreign_key "event_hosts", "users"
  add_foreign_key "pies_entries", "users"
  add_foreign_key "team_assignments", "users", column: "individual_id"
  add_foreign_key "team_assignments", "users", column: "leader_id"
end
