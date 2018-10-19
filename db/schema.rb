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

ActiveRecord::Schema.define(version: 20181013102052) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.string   "user_id",     limit: 255
    t.datetime "begin_date"
    t.datetime "end_date"
    t.string   "group",       limit: 255
    t.text     "description", limit: 65535
    t.integer  "room_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",       limit: 255
    t.string   "phone",       limit: 255
    t.datetime "deleted_at"
  end

  add_index "bookings", ["deleted_at"], name: "index_bookings_on_deleted_at", using: :btree
  add_index "bookings", ["room_id"], name: "index_bookings_on_room_id", using: :btree

  create_table "party_reports", force: :cascade do |t|
    t.integer  "booking_id",                 limit: 4
    t.string   "party_responsible_name",     limit: 255
    t.string   "party_responsible_phone",    limit: 255
    t.string   "party_responsible_mail",     limit: 255
    t.string   "co_party_responsible_name",  limit: 255
    t.string   "co_party_responsible_phone", limit: 255
    t.string   "co_party_responsible_mail",  limit: 255
    t.boolean  "liquor_license",             limit: 1
    t.boolean  "accepted",                   limit: 1
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "sent_at"
  end

  add_index "party_reports", ["booking_id"], name: "index_party_reports_on_booking_id", using: :btree
  add_index "party_reports", ["deleted_at"], name: "index_party_reports_on_deleted_at", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.boolean  "allow_party", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "only_group",  limit: 1
    t.string   "color",       limit: 255
  end

  create_table "rooms_rules", id: false, force: :cascade do |t|
    t.integer "room_id", limit: 4
    t.integer "rule_id", limit: 4
  end

  add_index "rooms_rules", ["room_id"], name: "index_rooms_rules_on_room_id", using: :btree
  add_index "rooms_rules", ["rule_id"], name: "index_rooms_rules_on_rule_id", using: :btree

  create_table "rules", force: :cascade do |t|
    t.integer  "day_mask",   limit: 4
    t.datetime "start_date"
    t.datetime "stop_date"
    t.time     "start_time"
    t.time     "stop_time"
    t.boolean  "allow",      limit: 1
    t.integer  "prio",       limit: 4
    t.text     "reason",     limit: 65535
    t.string   "title",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.boolean  "active",     limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "whitelist_items", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.time     "begin_time"
    t.time     "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "days_in_week", limit: 4
    t.date     "rule_start"
    t.date     "rule_end"
    t.boolean  "blacklist",    limit: 1
  end

  add_foreign_key "party_reports", "bookings"
end
