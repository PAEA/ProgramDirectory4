class FieldsString < ApplicationRecord

  def self.get_field_values( program_id, field_id )
    select(:field_value, :field_value_temp).where( program_id: program_id, field_id: field_id )
  end

  def self.select_fields_by_filter( filter_field )
    select(:field_value).distinct.where( field_id: filter_field ).sort_by { |item| item.field_value.to_i }
  end

  def self.select_fields_by_keywords( search_query )
    distinct.where( search_query )
  end

  def self.select_programs_by_filter_value( field_name, these_values )
    find_by_sql("
    SELECT fields_strings.program_id as program_id
      FROM fields_strings, field_names
      WHERE field_names.field_name = '" + field_name + "'
        AND field_names.id = fields_strings.field_id
        AND fields_strings.field_value IN (" + these_values + ")" )
  end

  def self.select_card_fields( card_fields, get_programs )
    find_by_sql("
    SELECT *
      FROM (
        SELECT fields_strings.program_id, fields_strings.field_id,
          field_names.display_field_name, field_names.field_name,
          fields_strings.field_value
          FROM field_names, fields_strings
          WHERE field_names.id = fields_strings.field_id
            AND field_names.field_name IN (" +  card_fields + ")
            AND fields_strings.program_id IN (" + get_programs + ")
        UNION
        SELECT fields_integers.program_id, fields_integers.field_id,
          field_names.display_field_name, field_names.field_name,
          fields_integers.field_value
          FROM field_names, fields_integers
          WHERE field_names.id = fields_integers.field_id
            AND field_names.field_name IN (" +  card_fields + ")
            AND fields_integers.program_id IN (" + get_programs + ")
        UNION
        SELECT fields_texts.program_id, fields_texts.field_id,
          field_names.display_field_name, field_names.field_name,
          fields_texts.field_value
          FROM field_names, fields_texts
          WHERE field_names.id = fields_texts.field_id
            AND field_names.field_name IN (" +  card_fields + ")
            AND fields_texts.program_id IN (" + get_programs + ")
        UNION
        SELECT fields_decimals.program_id, fields_decimals.field_id,
          field_names.display_field_name, field_names.field_name,
          fields_decimals.field_value
          FROM field_names, fields_decimals
          WHERE field_names.id = fields_decimals.field_id
            AND field_names.field_name IN (" +  card_fields + ")
            AND fields_decimals.program_id IN (" + get_programs + ") ) as tables_union
      ORDER BY tables_union.program_id, tables_union.field_id
    " )
  end

end
