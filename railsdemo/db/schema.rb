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

ActiveRecord::Schema.define(:version => 20121106075523) do

  create_table "notables", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "number_of_t"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "page_number"
    t.string   "page_quality"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "subject_id"
  end

  create_table "pages_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "page_id"
  end

  add_index "pages_users", ["user_id", "page_id"], :name => "index_pages_users_on_user_id_and_page_id"

  create_table "subjects", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "sub_first_name"
    t.string   "sub_last_name"
  end

  create_table "users", :force => true do |t|
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "email",                         :default => "", :null => false
    t.string   "password",        :limit => 40
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.string   "new_column1"
    t.string   "new_column2"
  end

  create_table "zombies", :force => true do |t|
    t.string   "name"
    t.text     "bio"
    t.integer  "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
