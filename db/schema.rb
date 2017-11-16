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

ActiveRecord::Schema.define(version: 20171116150105) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "data_table_config_id"
    t.string   "category",             limit: 100
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["data_table_config_id"], name: "index_categories_on_data_table_config_id", using: :btree
  end

  create_table "custom_filters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "custom_filter", limit: 70
    t.string   "source",        limit: 5
    t.integer  "display_order", limit: 2,  default: 99
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "data_table_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "program_id"
    t.integer  "table_name_id"
    t.integer  "rows",           limit: 2
    t.integer  "columns",        limit: 2
    t.boolean  "has_categories"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["program_id"], name: "index_data_table_configs_on_program_id", using: :btree
    t.index ["table_name_id"], name: "index_data_table_configs_on_table_name_id", using: :btree
  end

  create_table "data_tables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "data_table_config_id"
    t.integer  "main_header_id"
    t.integer  "sub_header_id"
    t.integer  "category_id"
    t.text     "cell_value",           limit: 65535
    t.text     "cell_value_temp",      limit: 65535
    t.integer  "program_id"
    t.integer  "cell_row",             limit: 2
    t.integer  "cell_column",          limit: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["category_id"], name: "index_data_tables_on_category_id", using: :btree
    t.index ["data_table_config_id"], name: "index_data_tables_on_data_table_config_id", using: :btree
    t.index ["main_header_id"], name: "index_data_tables_on_main_header_id", using: :btree
    t.index ["program_id"], name: "index_data_tables_on_program_id", using: :btree
    t.index ["sub_header_id"], name: "index_data_tables_on_sub_header_id", using: :btree
  end

  create_table "display_sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "section_name",    limit: 60
    t.integer  "section_order",   limit: 2
    t.string   "section_to_link", limit: 80
    t.string   "section_type",    limit: 5
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "field_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "field_name",         limit: 70
    t.string   "display_field_name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "fields_decimals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "program_id"
    t.integer  "field_id"
    t.decimal  "field_value",      precision: 10
    t.decimal  "field_value_temp", precision: 10
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "fields_integers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "program_id"
    t.integer  "field_id"
    t.integer  "field_value"
    t.integer  "field_value_temp"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "fields_strings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "program_id"
    t.integer  "field_id"
    t.string   "field_value"
    t.string   "field_value_temp"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "fields_texts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "program_id"
    t.integer  "field_id"
    t.text     "field_value",      limit: 65535
    t.text     "field_value_temp", limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "program_id"
    t.integer  "field_id"
    t.text     "old_value",  limit: 65535
    t.text     "new_value",  limit: 65535
    t.integer  "user_id"
    t.string   "action"
    t.integer  "action_by"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["program_id", "field_id", "created_at"], name: "index_logs_on_program_id_and_field_id_and_created_at", using: :btree
  end

  create_table "main_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "table_name_id"
    t.string   "header",        limit: 95
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["table_name_id"], name: "index_main_headers_on_table_name_id", using: :btree
  end

  create_table "programs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "program",        limit: 100
    t.string   "program_string", limit: 90
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.date     "editing_from"
    t.date     "editing_to"
    t.string   "email_notifications"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "settings_fields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "settings_roles_id"
    t.integer  "display_sections_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["display_sections_id"], name: "index_settings_fields_on_display_sections_id", using: :btree
    t.index ["settings_roles_id"], name: "index_settings_fields_on_settings_roles_id", using: :btree
  end

  create_table "settings_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "role",       limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "sub_headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "table_name_id"
    t.string   "subheader",     limit: 50
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["table_name_id"], name: "index_sub_headers_on_table_name_id", using: :btree
  end

  create_table "table_names", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "table_name",         limit: 70
    t.string   "display_table_name", limit: 100
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "login"
    t.string   "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login", unique: true, using: :btree
  end

end
