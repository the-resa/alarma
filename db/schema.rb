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

ActiveRecord::Schema.define(:version => 20111221184439) do

  create_table "coordinates", :force => true do |t|
    t.integer "x"
    t.integer "y"
  end

  create_table "moments", :force => true do |t|
    t.integer "year"
    t.integer "month"
  end

  create_table "setups", :force => true do |t|
    t.integer "zone",     :default => 1
    t.integer "scenario", :default => 1
    t.integer "variable", :default => 1
  end

  create_table "values", :force => true do |t|
    t.float   "result"
    t.integer "coordinate_id"
    t.integer "moment_id"
    t.integer "setup_id"
  end

end
