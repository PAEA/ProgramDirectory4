class MainHeader < ApplicationRecord

  def self.select_headers_by_table_name_id( table_name_id )
    where( :table_name_id => table_name_id ).order(id: :asc)
  end

end
