class FieldsString < ApplicationRecord

  def self.select_fields_by_filter( filter_field )
    select(:field_value).distinct.where( field_id: filter_field )
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

end
