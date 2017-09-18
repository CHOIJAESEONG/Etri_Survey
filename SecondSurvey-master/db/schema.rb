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

ActiveRecord::Schema.define(version: 20170105043651) do

  create_table "clists", primary_key: "CID", id: :integer, default: 0, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "Category"
    t.string   "ProgramName"
    t.integer  "EpisodeNum"
    t.string   "VideoURL"
    t.string   "VideoFileName"
    t.string   "VideoThumb"
    t.float    "FPS",               limit: 24
    t.datetime "RegisterDateTime"
    t.datetime "LastSavedDateTime"
    t.integer  "TagStatus"
    t.string   "User"
    t.string   "ProgramNameKor"
  end

  create_table "filterings", primary_key: "sUserID", id: :string, default: "", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "serviceProvider"
    t.integer "degree"
    t.integer "price"
  end

  create_table "first_queries", primary_key: "queryID", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "sUserID"
    t.string   "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sUserID"], name: "fk_sUserID_from_users_for_first_queries", using: :btree
  end

  create_table "first_query_surveys", primary_key: ["queryID", "shotID"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "queryID",    default: 0, null: false
    t.integer  "shotID",     default: 0, null: false
    t.integer  "totalScore"
    t.integer  "correct"
    t.integer  "preference"
    t.string   "reason"
    t.boolean  "isSelect"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "first_query_tags", primary_key: ["queryID", "shotID", "tagDesc"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "queryID",    default: 0,  null: false
    t.integer  "shotID",     default: 0,  null: false
    t.string   "tagDesc",    default: "", null: false
    t.integer  "tagID"
    t.integer  "tagScore"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "first_surveys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "cID"
    t.integer  "shotID"
    t.datetime "timestamp"
    t.string   "fileName"
    t.float    "preference", limit: 24
    t.string   "reason"
    t.string   "sUserID",    limit: 20, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["cID"], name: "fk_cID_from_clists_first", using: :btree
    t.index ["sUserID"], name: "fk_sUserID_from_users_first", using: :btree
  end

  create_table "max_queries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "max"
  end

  create_table "second_queries", primary_key: "queryID", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "sUserID"
    t.string   "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sUserID"], name: "fk_sUserID_from_users_for_second_queries", using: :btree
  end

  create_table "second_query_surveys", primary_key: ["queryID", "shotID"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "queryID",      default: 0, null: false
    t.integer  "shotID",       default: 0, null: false
    t.integer  "firstQueryID"
    t.integer  "totalScore"
    t.integer  "correct"
    t.integer  "similarity"
    t.integer  "preference"
    t.string   "reason"
    t.boolean  "isSelect"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["firstQueryID"], name: "fk_firstQueryID_from_first_queries_for_survey", using: :btree
  end

  create_table "second_query_tags", primary_key: ["queryID", "shotID", "tagDesc"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "queryID",    default: 0,  null: false
    t.integer  "shotID",     default: 0,  null: false
    t.string   "tagDesc",    default: "", null: false
    t.integer  "tagID"
    t.integer  "tagScore"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "shot_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "ShotID"
    t.integer "ShotNum"
    t.string  "StartFrame"
    t.string  "EndFrame"
    t.string  "ThumbURL"
    t.integer "CID"
    t.index ["CID"], name: "fk_CID_from_clist", using: :btree
  end

  create_table "users", primary_key: "sUserID", id: :string, limit: 20, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",            limit: 20
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest"
    t.date     "birthday"
    t.string   "sex",             limit: 2
    t.string   "married",         limit: 2
    t.string   "children",        limit: 2
    t.string   "job",             limit: 100
    t.string   "hobby",           limit: 100
    t.integer  "currentShot"
    t.integer  "group"
    t.string   "phone"
    t.string   "company"
    t.integer  "querys"
  end

  add_foreign_key "filterings", "users", column: "sUserID", primary_key: "sUserID", name: "fk_sUserID_from_users", on_delete: :cascade
  add_foreign_key "first_queries", "users", column: "sUserID", primary_key: "sUserID", name: "fk_sUserID_from_users_for_first_queries", on_delete: :cascade
  add_foreign_key "first_query_surveys", "first_queries", column: "queryID", primary_key: "queryID", name: "fk_queryID_from_first_queries_for_survey", on_delete: :cascade
  add_foreign_key "first_query_tags", "first_queries", column: "queryID", primary_key: "queryID", name: "fk_queryID_from_first_queries", on_delete: :cascade
  add_foreign_key "first_surveys", "clists", column: "cID", primary_key: "CID", name: "fk_cID_from_clists_first", on_delete: :cascade
  add_foreign_key "first_surveys", "users", column: "sUserID", primary_key: "sUserID", name: "fk_sUserID_from_users_first", on_delete: :cascade
  add_foreign_key "second_queries", "users", column: "sUserID", primary_key: "sUserID", name: "fk_sUserID_from_users_for_second_queries", on_delete: :cascade
  add_foreign_key "second_query_surveys", "first_queries", column: "firstQueryID", primary_key: "queryID", name: "fk_firstQueryID_from_first_queries_for_survey", on_delete: :cascade
  add_foreign_key "second_query_surveys", "second_queries", column: "queryID", primary_key: "queryID", name: "fk_queryID_from_second_queries_for_survey", on_delete: :cascade
  add_foreign_key "second_query_tags", "second_queries", column: "queryID", primary_key: "queryID", name: "fk_queryID_from_second_queries", on_delete: :cascade
  add_foreign_key "shot_infos", "clists", column: "CID", primary_key: "CID", name: "fk_CID_from_clist", on_delete: :cascade
end
