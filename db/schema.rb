# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150419162002) do

  create_table "bookings", force: :cascade do |t|
    t.string   "user_id"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.string   "group"
    t.text     "description"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "phone"
    t.datetime "deleted_at"
  end

  add_index "bookings", ["deleted_at"], name: "index_bookings_on_deleted_at"
  add_index "bookings", ["room_id"], name: "index_bookings_on_room_id"

  create_table "party_reports", force: :cascade do |t|
    t.integer  "booking_id"
    t.string   "party_responsible_name"
    t.string   "party_responsible_phone"
    t.string   "party_responsible_mail"
    t.string   "co_party_responsible_name"
    t.string   "co_party_responsible_phone"
    t.string   "co_party_responsible_mail"
    t.boolean  "liquor_license"
    t.boolean  "sent"
    t.boolean  "accepted"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "deleted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "party_reports", ["booking_id"], name: "index_party_reports_on_booking_id"
  add_index "party_reports", ["deleted_at"], name: "index_party_reports_on_deleted_at"

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.boolean  "allow_party"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "only_group"
  end

  create_table "rooms_rules", id: false, force: :cascade do |t|
    t.integer "room_id"
    t.integer "rule_id"
  end

  add_index "rooms_rules", ["room_id"], name: "index_rooms_rules_on_room_id"
  add_index "rooms_rules", ["rule_id"], name: "index_rooms_rules_on_rule_id"

  create_table "rules", force: :cascade do |t|
    t.integer  "day_mask"
    t.datetime "start_date"
    t.datetime "stop_date"
    t.time     "start_time"
    t.time     "stop_time"
    t.boolean  "allow"
    t.integer  "prio"
    t.text     "reason"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string   "cid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick"
    t.string   "mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "whitelist_items", force: :cascade do |t|
    t.string   "title"
    t.time     "begin_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "days_in_week"
    t.date     "rule_start"
    t.date     "rule_end"
    t.boolean  "blacklist"
  end

end
