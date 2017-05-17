class DataTableConfig < ApplicationRecord

  def self.select_tables_by_program_id( id )
    where( program_id: id )
  end

end
