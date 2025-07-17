# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_17_184628) do
  create_table "course_offerings", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "term_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "term_id"], name: "index_course_offerings_on_course_id_and_term_id", unique: true
    t.index ["course_id"], name: "index_course_offerings_on_course_id"
    t.index ["term_id"], name: "index_course_offerings_on_term_id"
  end

  create_table "courses", force: :cascade do |t|
    t.integer "school_id", null: false
    t.string "subject", null: false
    t.integer "number", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id", "subject", "number"], name: "index_courses_on_school_id_and_subject_and_number", unique: true
    t.index ["school_id", "subject"], name: "index_courses_on_school_id_and_subject"
    t.index ["school_id"], name: "index_courses_on_school_id"
  end

  create_table "licenses", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "term_count", default: 1, null: false
    t.index ["code"], name: "index_licenses_on_code", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "subscription_id"
    t.integer "course_offering_id"
    t.integer "amount", null: false
    t.string "provider", null: false
    t.string "provider_transaction_id", null: false
    t.datetime "completed_at"
    t.datetime "refunded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed_at"], name: "index_payments_on_completed_at"
    t.index ["course_offering_id"], name: "index_payments_on_course_offering_id"
    t.index ["provider_transaction_id"], name: "index_payments_on_provider_transaction_id", unique: true
    t.index ["subscription_id"], name: "index_payments_on_subscription_id"
    t.index ["user_id", "course_offering_id"], name: "index_payments_on_user_id_and_course_offering_id", unique: true
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_name", null: false
    t.index ["name"], name: "index_schools_on_name"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "term_id", null: false
    t.integer "license_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["license_id"], name: "index_subscriptions_on_license_id"
    t.index ["status"], name: "index_subscriptions_on_status"
    t.index ["term_id"], name: "index_subscriptions_on_term_id"
    t.index ["user_id", "term_id"], name: "index_subscriptions_on_user_id_and_term_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "terms", force: :cascade do |t|
    t.integer "school_id", null: false
    t.string "name", null: false
    t.integer "year", null: false
    t.integer "sequence_num", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id", "name"], name: "index_terms_on_school_id_and_name", unique: true
    t.index ["school_id", "year", "sequence_num"], name: "index_terms_on_school_id_and_year_and_sequence_num", unique: true
    t.index ["school_id"], name: "index_terms_on_school_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
  end

  add_foreign_key "course_offerings", "courses"
  add_foreign_key "course_offerings", "terms"
  add_foreign_key "courses", "schools"
  add_foreign_key "payments", "course_offerings"
  add_foreign_key "payments", "subscriptions"
  add_foreign_key "payments", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscriptions", "licenses"
  add_foreign_key "subscriptions", "terms"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "terms", "schools"
end
