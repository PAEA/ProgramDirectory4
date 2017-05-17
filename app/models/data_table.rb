class DataTable < ApplicationRecord

  def self.select_tables_by_filter( filter_field )
    find_by_sql("
      SELECT distinct categories.category as field_value
        FROM data_tables, main_headers, categories, data_table_configs, table_names, programs
        WHERE table_names.table_name = '" + filter_field + "'
          AND data_table_configs.table_name_id = table_names.id
          AND categories.data_table_config_id = data_table_configs.id
          AND data_tables.category_id = categories.id
          AND data_tables.header_id = main_headers.id
          AND main_headers.table_name_id = table_names.id
          AND data_table_configs.id = data_tables.data_table_config_id
          AND data_tables.program_id = programs.id order by program")
  end

  def self.select_table_config_by_program_id( id, table_configuration_id )
    where( :program_id => id ).where( :data_table_config_id => table_configuration_id )
  end

end
