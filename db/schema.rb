# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100720084654) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "sponsor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "keyword",         :null => false
    t.text     "description"
    t.text     "vcalendar"
    t.string   "feed_url"
    t.string   "alert_offsets"
    t.datetime "checked_at"
    t.datetime "feed_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
  end

  add_index "locations", ["group_id"], :name => "index_locations_on_group_id"

end
