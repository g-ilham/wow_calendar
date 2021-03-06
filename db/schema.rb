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

ActiveRecord::Schema.define(version: 20151219135553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "title",                              null: false
    t.integer  "user_id",                            null: false
    t.boolean  "all_day",     default: false,        null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "parent_id"
    t.string   "repeat_type", default: "not_repeat"
  end

  add_index "events", ["parent_id"], name: "index_events_on_parent_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "vkontakte_url"
    t.string   "vkontakte_username"
    t.string   "vkontakte_uid"
    t.string   "vkontakte_nickname"
    t.string   "facebook_url"
    t.string   "facebook_username"
    t.string   "facebook_uid"
    t.string   "photo"
    t.string   "provider"
    t.boolean  "in_fifteen_minutes",     default: false
    t.boolean  "in_hour",                default: false
    t.boolean  "in_day",                 default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_uid"], name: "index_users_on_facebook_uid", unique: true, using: :btree
  add_index "users", ["facebook_url"], name: "index_users_on_facebook_url", unique: true, using: :btree
  add_index "users", ["facebook_username"], name: "index_users_on_facebook_username", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["vkontakte_nickname"], name: "index_users_on_vkontakte_nickname", unique: true, using: :btree
  add_index "users", ["vkontakte_uid"], name: "index_users_on_vkontakte_uid", unique: true, using: :btree
  add_index "users", ["vkontakte_url"], name: "index_users_on_vkontakte_url", unique: true, using: :btree
  add_index "users", ["vkontakte_username"], name: "index_users_on_vkontakte_username", unique: true, using: :btree

  add_foreign_key "events", "users"
end
