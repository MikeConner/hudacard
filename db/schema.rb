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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130708043600) do

  create_table "btc_transactions", :force => true do |t|
    t.datetime "txn_date"
    t.integer  "satoshi_in"
    t.integer  "satoshi_out"
    t.string   "from_address"
    t.string   "to_address"
    t.integer  "user_id"
    t.string   "label"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "cards", :force => true do |t|
    t.string   "suit"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "games", :force => true do |t|
    t.float    "bet"
    t.string   "card1"
    t.string   "card2"
    t.string   "card3"
    t.string   "card4"
    t.string   "card5"
    t.integer  "user_id"
    t.float    "payout"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "session_id"
    t.string   "color"
    t.string   "security_code"
    t.string   "game_key"
    t.float    "payout_ratio"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.float    "balance"
    t.string   "bitcoin_inbound"
    t.float    "total_bitcoin_in"
    t.float    "total_bitcoin_out"
    t.float    "total_address_balance"
    t.string   "random_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
