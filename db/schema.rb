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

ActiveRecord::Schema.define(version: 20160329094656) do

  create_table "odgovors", force: :cascade do |t|
    t.text     "opcija",      limit: 65535
    t.boolean  "tacan"
    t.integer  "question_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "odgovors", ["question_id"], name: "index_odgovors_on_question_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "pitanje",    limit: 65535
    t.integer  "quiz_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id", using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.string   "naziv",      limit: 255
    t.text     "opis",       limit: 65535
    t.datetime "datumstart"
    t.datetime "datumstop"
    t.integer  "pokusaja",   limit: 4
    t.boolean  "published"
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "quizzes", ["user_id"], name: "index_quizzes_on_user_id", using: :btree

  create_table "rezultats", force: :cascade do |t|
    t.string   "postotak",   limit: 255
    t.integer  "tacnihodg",  limit: 4
    t.datetime "dtstart"
    t.datetime "dtkraj"
    t.integer  "quiz_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "rezultats", ["quiz_id"], name: "index_rezultats_on_quiz_id", using: :btree
  add_index "rezultats", ["user_id"], name: "index_rezultats_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
  end

end
