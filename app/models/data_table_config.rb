class DataTableConfig < ApplicationRecord

  belongs_to :program
  belongs_to :table_name

  def self.select_tables_by_program_id( id )
    where( program_id: id )
  end

end
