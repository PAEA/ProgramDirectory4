class Category < ApplicationRecord

  belongs_to :data_table_config

  def self.select_categories_by_table_config_id( table_configuration_id )
    where( :data_table_config_id => table_configuration_id ).order(id: :desc)
  end

end
