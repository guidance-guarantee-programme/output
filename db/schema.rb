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

ActiveRecord::Schema.define(version: 20150304071148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointment_summaries", force: :cascade do |t|
    t.string   "name",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "email_address"
    t.date     "date_of_appointment"
    t.money    "value_of_pension_pots", scale: 2
    t.string   "income_in_retirement"
    t.string   "guider_organisation"
    t.string   "guider_name"
    t.boolean  "continue_working"
    t.boolean  "unsure"
    t.boolean  "leave_inheritance"
    t.boolean  "wants_flexibility"
    t.boolean  "wants_security"
    t.boolean  "wants_lump_sum"
    t.boolean  "poor_health"
  end

end
