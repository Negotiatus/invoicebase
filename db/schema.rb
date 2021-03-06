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

ActiveRecord::Schema.define(version: 20171015165451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "external_records", force: :cascade do |t|
    t.string "invoice_number"
    t.string "reference_number"
    t.string "negotiatus_reference_number"
    t.date "date"
    t.integer "amount_cents"
    t.string "delivery_address_string"
    t.string "delivery_address_zipcode"
    t.integer "reconciliation_id"
    t.datetime "paid_at"
    t.boolean "payable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vendor_name"
    t.index ["date"], name: "index_external_records_on_date"
    t.index ["paid_at", "payable"], name: "index_external_records_on_paid_at_and_payable"
  end

  create_table "guesses", force: :cascade do |t|
    t.bigint "external_record_id"
    t.bigint "internal_record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "confidence", default: 0.0
    t.index ["external_record_id"], name: "index_guesses_on_external_record_id"
    t.index ["internal_record_id"], name: "index_guesses_on_internal_record_id"
  end

  create_table "internal_records", force: :cascade do |t|
    t.string "external_reference_number"
    t.string "negotiatus_reference_number"
    t.date "date"
    t.integer "amount_cents"
    t.string "delivery_address_string"
    t.string "delivery_address_zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vendor_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "image"
    t.string "email", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

end
