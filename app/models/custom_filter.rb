class CustomFilter < ApplicationRecord

  def self.select_all_filters_sorted_by_display_order
    find_by_sql("
    SELECT * FROM (
      SELECT custom_filters.custom_filter,
        custom_filters.source,
        custom_filters.display_order,
        field_names.display_field_name as display_name
        FROM custom_filters, field_names
        WHERE custom_filters.custom_filter = field_names.field_name
          AND custom_filters.source = 'field'
      UNION
      SELECT custom_filters.custom_filter,
        custom_filters.source,
        custom_filters.display_order,
        table_names.display_table_name as display_name
        FROM custom_filters, table_names
        WHERE custom_filters.custom_filter = table_names.table_name
          AND custom_filters.source = 'table') as tables_union
      ORDER BY tables_union.display_order
    ")
  end

end
