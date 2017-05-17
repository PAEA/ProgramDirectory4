class Program < ApplicationRecord

  def self.select_all_programs_sorted_alphabetically
    all.order(:program_string)
  end

  def self.select_programs_sorted_alphabetically( get_programs )
    where( "id IN (?)", get_programs ).order(:program_string)
  end

  def self.select_programs_by_filter_value( field_name, these_values )
    find_by_sql( "
      SELECT DISTINCT programs.id
        FROM data_tables, main_headers, categories, data_table_configs, table_names, programs
        WHERE table_names.table_name = '" + field_name + "'
          AND data_table_configs.table_name_id = table_names.id
          AND categories.data_table_config_id = data_table_configs.id
          AND data_tables.category_id = categories.id
          AND data_tables.header_id = main_headers.id
          AND main_headers.table_name_id = table_names.id
          AND data_table_configs.id = data_tables.data_table_config_id
          AND data_tables.program_id = programs.id
          AND categories.category in (" + these_values + ")
          AND main_headers.header = 'Yes'" )
  end

end
