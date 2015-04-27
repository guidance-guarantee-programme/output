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

ActiveRecord::Schema.define(version: 20150427100026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointment_summaries", force: :cascade do |t|
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
    t.date     "date_of_appointment"
    t.money    "value_of_pension_pots",                scale: 2
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
    t.integer  "user_id"
    t.string   "reference_number"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "town"
    t.string   "county"
    t.string   "postcode"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "format_preference"
    t.string   "has_defined_contribution_pension"
    t.money    "upper_value_of_pension_pots",          scale: 2
    t.boolean  "value_of_pension_pots_is_approximate"
    t.string   "country",                                        default: "United Kingdom"
  end

  add_index "appointment_summaries", ["user_id"], name: "index_appointment_summaries_on_user_id", using: :btree

  create_table "appointment_summaries_batches", force: :cascade do |t|
    t.integer "appointment_summary_id"
    t.integer "batch_id"
  end

  add_index "appointment_summaries_batches", ["appointment_summary_id"], name: "index_appointment_summaries_batches_on_appointment_summary_id", using: :btree
  add_index "appointment_summaries_batches", ["batch_id"], name: "index_appointment_summaries_batches_on_batch_id", using: :btree

  create_table "batches", force: :cascade do |t|
    t.datetime "processed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "organisation"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "appointment_summaries_batches", "appointment_summaries"
  add_foreign_key "appointment_summaries_batches", "batches"
end
