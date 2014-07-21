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

ActiveRecord::Schema.define(version: 20140721141852) do

  create_table "categories", force: true do |t|
    t.string "name"
  end

  create_table "follow_relationships", force: true do |t|
    t.integer "follower_id"
    t.integer "followed_id"
  end

  create_table "invite_users", force: true do |t|
    t.integer  "invitor_id"
    t.string   "recipient_email"
    t.string   "token"
    t.string   "recipient_name"
    t.string   "recipient_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.string   "reference_id"
    t.integer  "amount"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "cancel_at_period_end"
  end

  create_table "pw_resets", force: true do |t|
    t.integer "user_id"
    t.string  "token"
  end

  create_table "queue_items", force: true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "rating"
    t.text     "review_description"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "customer_token"
    t.boolean  "active"
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "large_cover"
    t.string   "small_cover"
    t.string   "url"
  end

end
