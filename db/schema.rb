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

ActiveRecord::Schema.define(version: 20170201030605) do

  create_table "about", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "state",               limit: 20
    t.string "university",                        null: false
    t.string "school",                            null: false
    t.string "dean",                limit: 50
    t.text   "general_information", limit: 65535
    t.text   "mission",             limit: 65535
  end

  create_table "curriculum", primary_key: "school_id", id: :integer, default: 0, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "state",                  limit: 20
    t.string "university",                           null: false
    t.string "school",                               null: false
    t.text   "curriculum",             limit: 65535
    t.string "research_opportunities", limit: 3
    t.string "research_types",         limit: 10
    t.string "degree_programs",        limit: 50
    t.index ["school_id"], name: "ix_schoolid", using: :btree
  end

  create_table "fast_facts", primary_key: "school_id", id: :integer, default: 0, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string  "state",                limit: 20
    t.string  "university",                      null: false
    t.string  "school",                          null: false
    t.string  "type_of_institution",  limit: 50
    t.string  "year_opened",          limit: 4
    t.string  "term_type",            limit: 50
    t.integer "time_to_degree",       limit: 2
    t.string  "start_month",          limit: 10
    t.string  "doctoral_degree",      limit: 10
    t.integer "targeted_predoctoral", limit: 2
    t.integer "targeted_class_size",  limit: 2
    t.string  "campus_setting",       limit: 20
    t.string  "campus_housing",       limit: 20
    t.index ["school_id"], name: "ix_schoolid", using: :btree
  end

  create_table "schools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "state"
    t.string   "university"
    t.string   "school"
    t.string   "dean"
    t.text     "general_information",    limit: 65535
    t.text     "mission",                limit: 65535
    t.text     "curriculum",             limit: 65535
    t.string   "research_opportunities"
    t.string   "research_types"
    t.string   "degree_programs"
    t.string   "type_of_institution"
    t.string   "year_opened"
    t.string   "term_type"
    t.string   "time_to_degree"
    t.string   "start_month"
    t.string   "doctoral_degree"
    t.string   "targeted_predoctoral"
    t.string   "targeted_class_size"
    t.string   "campus_setting"
    t.string   "campus_housing"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

end
