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

ActiveRecord::Schema.define(version: 20140228171429) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.string   "account_type", limit: 5
    t.boolean  "publishable"
    t.boolean  "primary"
    t.boolean  "active"
    t.string   "username"
    t.string   "email"
    t.string   "cred1"
    t.string   "cred2"
    t.string   "cred3"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

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
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "clients", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.text     "address"
    t.string   "phone"
    t.string   "alternate_phone"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "name_on_twitter"
    t.string   "screen_name"
    t.string   "url"
    t.string   "profile_image_url"
    t.string   "location"
    t.text     "description"
  end

  add_index "clients", ["email"], name: "index_clients_on_email", unique: true
  add_index "clients", ["reset_password_token"], name: "index_clients_on_reset_password_token", unique: true

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.binary   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "future_tweets", force: true do |t|
    t.string   "message"
    t.datetime "post_at"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keywords", force: true do |t|
    t.string   "phrase"
    t.boolean  "auto_follow",            default: false
    t.integer  "auto_follow_time_from",  default: 36000
    t.integer  "auto_follow_time_to",    default: 61200
    t.integer  "auto_follow_rate",       default: 1
    t.boolean  "auto_retweet",           default: false
    t.integer  "auto_retweet_time_from", default: 36000
    t.integer  "auto_retweet_time_to",   default: 61200
    t.integer  "auto_retweet_rate",      default: 1
    t.boolean  "auto_reply",             default: false
    t.integer  "auto_reply_time_from",   default: 36000
    t.integer  "auto_reply_time_to",     default: 61200
    t.integer  "auto_reply_rate",        default: 1
    t.string   "default_reply"
    t.boolean  "geocoded",               default: false
    t.string   "lattitude"
    t.string   "longitude"
    t.float    "radius",                 default: 300.0
    t.string   "notes"
    t.string   "color",                  default: "#AAAAAA"
    t.string   "nickname"
    t.integer  "priority"
    t.string   "language"
    t.integer  "max_count",              default: 50
    t.boolean  "email_notification",     default: false
    t.integer  "fetch_frequency",        default: 72
    t.string   "notification_frequency", default: "hourly"
    t.integer  "client_id"
    t.boolean  "read",                   default: false
    t.string   "created_by",             default: "system"
    t.string   "last_tweet"
    t.datetime "last_fetch"
    t.datetime "last_follow"
    t.datetime "last_retweet"
    t.integer  "tweets_yet",             default: 0
    t.integer  "follow_yet",             default: 0
    t.integer  "reply_yet",              default: 0
    t.datetime "last_reply"
    t.datetime "last_ai_training_at"
    t.datetime "last_ai_rating_at"
    t.string   "ai_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["client_id"], name: "index_keywords_on_client_id"

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "content_type"
    t.string   "remote_id"
    t.integer  "account_id"
    t.integer  "parent_id"
    t.string   "published_url"
    t.boolean  "is_draft",      default: true
    t.boolean  "posted",        default: false
    t.datetime "post_at"
    t.integer  "client_id"
    t.string   "created_by",    default: "System"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["account_id"], name: "index_posts_on_account_id"
  add_index "posts", ["client_id"], name: "index_posts_on_client_id"

  create_table "streams", force: true do |t|
    t.text     "content"
    t.string   "c2"
    t.string   "c3"
    t.string   "c4"
    t.string   "from_id"
    t.string   "author"
    t.integer  "post_id"
    t.string   "stream_type"
    t.integer  "account_id"
    t.string   "remote_url"
    t.string   "remote_id"
    t.integer  "parent"
    t.boolean  "read"
    t.datetime "posted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "streams", ["account_id"], name: "index_streams_on_account_id"
  add_index "streams", ["post_id"], name: "index_streams_on_post_id"

  create_table "tweets", force: true do |t|
    t.string   "author"
    t.string   "message",      limit: 400
    t.string   "twitter_uuid"
    t.datetime "posted_at"
    t.integer  "client_id"
    t.integer  "account_id"
    t.integer  "keyword_id"
    t.integer  "user_rating"
    t.integer  "ai_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
