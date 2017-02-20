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

ActiveRecord::Schema.define(version: 20170219000822) do

  create_table "about_old", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "state",               limit: 20
    t.string "university",                        null: false
    t.string "school",                            null: false
    t.string "dean",                limit: 50
    t.text   "general_information", limit: 65535
    t.text   "mission",             limit: 65535
  end

  create_table "abouts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "school"
    t.string   "state"
    t.string   "dean"
    t.text     "general_information", limit: 65535
    t.text     "mission",             limit: 65535
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "data_table_config_id"
    t.string   "category"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "curriculum_old", primary_key: "school_id", id: :integer, default: 0, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "state",                  limit: 20
    t.string "university",                           null: false
    t.string "school",                               null: false
    t.text   "curriculum",             limit: 65535
    t.string "research_opportunities", limit: 3
    t.string "research_types",         limit: 10
    t.string "degree_programs",        limit: 50
    t.index ["school_id"], name: "ix_schoolid", using: :btree
  end

  create_table "curriculums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "school"
    t.text     "curriculum",             limit: 65535
    t.string   "research_opportunities"
    t.string   "research_types"
    t.string   "degree_programs"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "data_table_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "program_id"
    t.integer  "table_name_id"
    t.integer  "rows"
    t.integer  "columns"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "data_tables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "data_table_config_id"
    t.integer  "header_id"
    t.integer  "subheader_id"
    t.integer  "extraheader_id"
    t.integer  "category_id"
    t.string   "cell_value"
    t.integer  "program_id"
    t.integer  "cell_row"
    t.integer  "cell_column"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "fast_facts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "school"
    t.string   "type_of_institution"
    t.integer  "year_opened"
    t.string   "term_type"
    t.integer  "time_to_degree"
    t.string   "start_month"
    t.string   "doctoral_degree"
    t.integer  "targeted_predoctoral"
    t.integer  "targeted_class_size"
    t.string   "campus_setting"
    t.string   "campus_housing"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "fast_facts_old", primary_key: "school_id", id: :integer, default: 0, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
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

  create_table "main_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "table_name_id"
    t.string   "header"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "programs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "program"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "sub_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "table_name_id"
    t.string   "subheader"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "table_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "table_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
