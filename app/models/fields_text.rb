class FieldsText < ApplicationRecord

  def self.select_fields_by_keywords( search_query )
    distinct.where( search_query )
  end
  
end
