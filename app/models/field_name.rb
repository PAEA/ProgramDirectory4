class FieldName < ApplicationRecord

  def self.select_fields_to_display( id )

    @field_string_length = '255'
    @field_string_type = 'string'
    @field_text_length = '1000'
    @field_text_type = 'text'
    @field_decimal_length = '10'
    @field_decimal_type = 'decimal'
    @field_integer_length = '10'
    @field_integer_type = 'integer'

    find_by_sql("
      SELECT *
        FROM
        (SELECT display_sections.id as display_sections_id, display_sections.section_name,
          display_sections.section_order,
          field_names.id as id, field_names.field_name as field_name,
          field_names.display_field_name as display_name,
          fields_strings.field_value, fields_strings.field_value_temp, 'field' as content_type,
          '" + @field_string_length + "' as field_size, '" + @field_string_type + "' as field_type
          FROM field_names, fields_strings, display_sections
          WHERE display_sections.section_to_link = field_names.field_name
            AND fields_strings.field_id = field_names.id
            AND field_names.field_name NOT LIKE 'filter_only_%'
            AND fields_strings.program_id = " + id.to_s + "
        UNION
        SELECT display_sections.id as display_sections_id, display_sections.section_name,
          display_sections.section_order,
          field_names.id as id, field_names.field_name as field_name,
          field_names.display_field_name as display_name,
          fields_texts.field_value, fields_texts.field_value_temp, 'field' as content_type,
          '" + @field_text_length + "' as field_size, '" + @field_text_type + "' as field_type
          FROM field_names, fields_texts, display_sections
          WHERE display_sections.section_to_link = field_names.field_name
            AND fields_texts.field_id = field_names.id
            AND field_names.field_name NOT LIKE 'filter_only_%'
            AND fields_texts.program_id = " + id.to_s + "
        UNION
        SELECT display_sections.id as display_sections_id, display_sections.section_name,
          display_sections.section_order,
          field_names.id as id, field_names.field_name as field_name,
          field_names.display_field_name as display_name,
          fields_decimals.field_value, fields_decimals.field_value_temp, 'field' as content_type,
          '" + @field_decimal_length + "' as field_size, '" + @field_decimal_type + "' as field_type
          FROM field_names, fields_decimals, display_sections
          WHERE display_sections.section_to_link = field_names.field_name
            AND fields_decimals.field_id = field_names.id
            AND field_names.field_name NOT LIKE 'filter_only_%'
            AND fields_decimals.program_id = " + id.to_s + "
        UNION
        SELECT display_sections.id as display_sections_id, display_sections.section_name,
          display_sections.section_order,
          field_names.id as id, field_names.field_name as field_name,
          field_names.display_field_name as display_name,
          fields_integers.field_value, fields_integers.field_value_temp, 'field' as content_type,
          '" + @field_integer_length + "' as field_size, '" + @field_integer_type + "' as field_type
          FROM field_names, fields_integers, display_sections
          WHERE display_sections.section_to_link = field_names.field_name
            AND fields_integers.field_id = field_names.id
            AND field_names.field_name NOT LIKE 'filter_only_%'
            AND fields_integers.program_id = " + id.to_s + "
        UNION
        SELECT display_sections.id as display_sections_id, display_sections.section_name,
          display_sections.section_order,
          table_names.id as id, table_names.table_name as field_name,
          table_names.display_table_name as display_name,
          0, 0, 'table' as content_type,
          '' as field_size, '' as field_type
          FROM display_sections, table_names, data_table_configs
          WHERE display_sections.section_to_link = table_names.table_name
            AND data_table_configs.table_name_id = table_names.id
            AND data_table_configs.program_id = " + id.to_s + ") as tables_union
        ORDER BY tables_union.section_order" )
    end

end
