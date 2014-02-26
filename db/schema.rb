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

ActiveRecord::Schema.define(version: 20140226212953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "areas", force: true do |t|
    t.integer  "restaurant_id",   null: false
    t.integer  "neighborhood_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aware_employees", force: true do |t|
    t.string   "verification",                  null: false
    t.string   "name",                          null: false
    t.boolean  "approved?",     default: false
    t.datetime "expiration",                    null: false
    t.integer  "restaurant_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cert_type",                     null: false
  end

  create_table "changeorders", force: true do |t|
    t.integer  "user_id",                       null: false
    t.integer  "restaurant_id",                 null: false
    t.string   "type",                          null: false
    t.boolean  "approved?",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cuisines", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "neighborhoods", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurant_roles", force: true do |t|
    t.integer  "aware_employee_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
  end

  create_table "restaurants", force: true do |t|
    t.string   "name",                             null: false
    t.string   "address",                          null: false
    t.string   "city",                             null: false
    t.string   "state",                            null: false
    t.string   "email",                            null: false
    t.string   "phone"
    t.string   "hours"
    t.string   "website"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "allergy_eats_url"
    t.integer  "zip",                              null: false
    t.integer  "total_employees",                  null: false
    t.integer  "percent_aware"
    t.text     "description"
    t.boolean  "is_visible",       default: true
    t.boolean  "approved",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                          null: false
    t.string   "logo"
    t.string   "repos"
    t.boolean  "kid_friendly"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "tags",             default: ""
    t.string   "image"
  end

  create_table "roles", force: true do |t|
    t.string   "role",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string "state",        null: false
    t.string "abbreviation", null: false
  end

  create_table "type_of_cuisines", force: true do |t|
    t.integer  "restaurant_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cuisine_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
