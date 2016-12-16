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

ActiveRecord::Schema.define(version: 20161216143340) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jobs", force: :cascade do |t|
    t.integer  "job_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_number"], name: "index_jobs_on_job_number", unique: true, using: :btree
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "job_id"
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.float    "hours"
    t.float    "quantity"
    t.string   "quantity_units"
    t.integer  "user_id",                    null: false
    t.text     "comments"
    t.integer  "bidtask_id",     default: 0, null: false
    t.index ["bidtask_id"], name: "index_tasks_on_bidtask_id", using: :btree
    t.index ["job_id"], name: "index_tasks_on_job_id", using: :btree
    t.index ["user_id"], name: "index_tasks_on_user_id", using: :btree
  end

  create_table "timecard_joins", force: :cascade do |t|
    t.integer  "timecard_id", null: false
    t.integer  "task_id",     null: false
    t.float    "task_hours"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "timecards", force: :cascade do |t|
    t.datetime "stop_time"
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "team_members"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
