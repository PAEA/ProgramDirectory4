class DataTable < ApplicationRecord

  belongs_to :data_table_config
  belongs_to :main_header
  has_many :sub_header
  has_many :category

  def self.get_cell_values( program_id, cell_id )
    select(:cell_value, :cell_value_temp).where( program_id: program_id, id: cell_id )
  end

  def self.select_tables_by_filter( filter_field )
    find_by_sql("
      SELECT distinct categories.category as field_value
        FROM data_tables, main_headers, categories, data_table_configs, table_names, programs
        WHERE table_names.table_name = '" + filter_field + "'
          AND data_table_configs.table_name_id = table_names.id
          AND categories.data_table_config_id = data_table_configs.id
          AND data_tables.category_id = categories.id
          AND data_tables.main_header_id = main_headers.id
          AND main_headers.table_name_id = table_names.id
          AND data_table_configs.id = data_tables.data_table_config_id
          AND data_tables.program_id = programs.id
        ORDER BY programs.program")
  end

  def self.select_table_config_by_program_id( program_id, table_configuration_id )
    where( :program_id => program_id ).where( :data_table_config_id => table_configuration_id )
  end

  def self.select_role_allowed_table_config_by_program_id( program_id, table_configuration_id, user_role_id )
    find_by_sql("
      SELECT data_tables.*
        FROM data_tables, data_table_configs, table_names, display_sections, settings_fields
        WHERE data_tables.data_table_config_id = " + table_configuration_id.to_s + "
          AND data_tables.program_id = " + program_id.to_s + "
          AND data_table_configs.id = " + table_configuration_id.to_s + "
          AND table_names.id = data_table_configs.table_name_id
          AND table_names.table_name = display_sections.section_to_link
          AND display_sections.id = settings_fields.display_sections_id
          AND settings_fields.settings_roles_id = " + user_role_id.to_s + "
        ORDER BY data_tables.id
    ")
  end

  def self.select_fields_by_keywords( search_query )
    distinct.where( search_query )
  end

end
