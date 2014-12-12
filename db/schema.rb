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

ActiveRecord::Schema.define(version: 20141212153329) do

  create_table "contacts", force: true do |t|
    t.integer  "user_id",                         null: false
    t.integer  "organization_id",                 null: false
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.boolean  "is_primary",      default: false, null: false
    t.boolean  "is_active",       default: true,  null: false
    t.boolean  "is_paused",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["organization_id"], name: "index_contacts_on_organization_id", using: :btree
  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "event_tracker_pings", force: true do |t|
    t.integer  "event_tracker_id"
    t.string   "task_length"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_tracker_pings", ["event_tracker_id"], name: "index_event_tracker_pings_on_event_tracker_id", using: :btree

  create_table "event_trackers", force: true do |t|
    t.integer  "user_id",                                    null: false
    t.integer  "organization_id",                            null: false
    t.string   "name",                                       null: false
    t.string   "email",                                      null: false
    t.string   "notes"
    t.integer  "interval_cd",                default: 2,     null: false
    t.string   "token",           limit: 16,                 null: false
    t.integer  "status_cd",                  default: 1,     null: false
    t.datetime "last_ping_at"
    t.integer  "sort_order",                 default: 0,     null: false
    t.boolean  "is_paused",                  default: false, null: false
    t.boolean  "is_deleted",                 default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_checked_at"
    t.datetime "next_check_at"
  end

  add_index "event_trackers", ["organization_id"], name: "index_event_trackers_on_organization_id", using: :btree
  add_index "event_trackers", ["user_id"], name: "index_event_trackers_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                    null: false
    t.integer  "organization_id"
    t.string   "role",                   default: "root"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
