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

ActiveRecord::Schema.define(:version => 20111213190525) do

  create_table "coordinates", :force => true do |t|
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coordinates_moments", :id => false, :force => true do |t|
    t.integer "coordinate_id"
    t.integer "moment_id"
  end

  create_table "moments", :force => true do |t|
    t.integer  "year"
    t.integer  "month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "values", :force => true do |t|
    t.integer  "zone",       :default => 1
    t.integer  "scenario",   :default => 1
    t.boolean  "var"
    t.float    "result"
    t.integer  "moment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
