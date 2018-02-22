class FieldsText < ApplicationRecord

  def self.get_field_values( program_id, field_id )
    select(:field_value, :field_value_temp).where( program_id: program_id, field_id: field_id )
  end

  def self.select_fields_by_keywords( search_query )
    distinct.where( search_query )
  end

end
