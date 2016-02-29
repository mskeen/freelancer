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

ActiveRecord::Schema.define(version: 20160229002553) do

  create_table "api_calls", force: :cascade do |t|
    t.integer  "api_key_id",  limit: 4
    t.datetime "starting_at"
    t.datetime "ending_at"
    t.integer  "usage_count", limit: 4, default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_calls", ["api_key_id"], name: "index_api_calls_on_api_key_id", using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.integer  "organization_id",   limit: 4,                  null: false
    t.integer  "user_id",           limit: 4,                  null: false
    t.string   "token",             limit: 255,                null: false
    t.boolean  "is_active",                     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hourly_rate_limit", limit: 4,   default: 1000
  end

  add_index "api_keys", ["organization_id"], name: "index_api_keys_on_organization_id", using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "alertable_id",   limit: 4
    t.string   "alertable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id", using: :btree

  create_table "event_tracker_pings", force: :cascade do |t|
    t.integer  "event_tracker_id", limit: 4
    t.string   "task_length",      limit: 255
    t.string   "comment",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_tracker_pings", ["event_tracker_id"], name: "index_event_tracker_pings_on_event_tracker_id", using: :btree

  create_table "event_trackers", force: :cascade do |t|
    t.integer  "user_id",         limit: 4,                   null: false
    t.integer  "organization_id", limit: 4,                   null: false
    t.string   "name",            limit: 255,                 null: false
    t.string   "notes",           limit: 255
    t.integer  "interval_cd",     limit: 4,   default: 2,     null: false
    t.string   "token",           limit: 16,                  null: false
    t.integer  "status_cd",       limit: 4,   default: 1,     null: false
    t.datetime "last_ping_at"
    t.integer  "sort_order",      limit: 4,   default: 0,     null: false
    t.boolean  "is_paused",                   default: false, null: false
    t.boolean  "is_deleted",                  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_checked_at"
    t.datetime "next_check_at"
  end

  add_index "event_trackers", ["organization_id"], name: "index_event_trackers_on_organization_id", using: :btree
  add_index "event_trackers", ["user_id"], name: "index_event_trackers_on_user_id", using: :btree

  create_table "log_monitors", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "site_id",    limit: 4
    t.integer  "status_cd",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "log_monitors", ["site_id"], name: "index_log_monitors_on_site_id", using: :btree
  add_index "log_monitors", ["user_id"], name: "index_log_monitors_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    limit: 4
  end

  create_table "sites", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "organization_id", limit: 4
    t.string   "name",            limit: 255
    t.string   "url",             limit: 255
    t.string   "host",            limit: 255
    t.string   "log_location",    limit: 255
    t.string   "token",           limit: 255
    t.integer  "interval_cd",     limit: 4
    t.integer  "status_cd",       limit: 4
    t.integer  "ping_status_cd",  limit: 4
    t.datetime "last_checked_at"
    t.datetime "next_check_at"
    t.boolean  "is_deleted"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "sites", ["organization_id"], name: "index_sites_on_organization_id", using: :btree
  add_index "sites", ["user_id"], name: "index_sites_on_user_id", using: :btree

  create_table "task_categories", force: :cascade do |t|
    t.integer  "user_id",         limit: 4,                   null: false
    t.integer  "organization_id", limit: 4,                   null: false
    t.string   "name",            limit: 255,                 null: false
    t.boolean  "is_shared",                   default: false, null: false
    t.boolean  "is_active",                   default: true,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_categories", ["organization_id"], name: "index_task_categories_on_organization_id", using: :btree
  add_index "task_categories", ["user_id"], name: "index_task_categories_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "user_id",              limit: 4,                   null: false
    t.integer  "task_category_id",     limit: 4,                   null: false
    t.string   "title",                limit: 255,                 null: false
    t.string   "description",          limit: 255, default: "",    null: false
    t.integer  "weight",               limit: 4,   default: 1,     null: false
    t.date     "due_date"
    t.integer  "frequency_cd",         limit: 4,   default: 0,     null: false
    t.boolean  "is_active",                        default: true,  null: false
    t.integer  "created_by_user_id",   limit: 4,                   null: false
    t.datetime "completed_at"
    t.integer  "completed_by_user_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "spawned_task_id",      limit: 4
    t.boolean  "send_reminder",                    default: false, null: false
    t.integer  "reminder_lead_days",   limit: 4,   default: 1,     null: false
    t.datetime "reminder_sent_at"
  end

  add_index "tasks", ["task_category_id"], name: "index_tasks_on_task_category_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255,                null: false
    t.integer  "organization_id",        limit: 4
    t.integer  "role_cd",                limit: 4,   default: 1
    t.boolean  "is_active",                          default: true, null: false
    t.boolean  "is_invited",                         default: true
    t.integer  "created_by_user_id",     limit: 4
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "log_monitors", "sites"
  add_foreign_key "log_monitors", "users"
  add_foreign_key "sites", "organizations"
  add_foreign_key "sites", "users"
end
