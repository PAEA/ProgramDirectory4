module ProgramsHelper

  def display_fields_and_tables(f)

    if ( f.content_type == 'field' )
      ("<p>" + f.display_name.to_s.strip + " <i>" + f.field_value.to_s.strip + "</i></p>").html_safe
    elsif ( f.content_type == 'table' )
      html = "<p>TABLE: " + f.display_name.to_s.strip + "</p>"

      data_table_config = @data_table_configs.find_by_table_name_id(f.id)

      html += "<table style='border: 1px solid grey;'>"
      for y in 1..data_table_config.rows
        html += "<tr>"
          # Left-aligned text for categories
          html += "<td style='border: 1px solid grey; text-align: left;'>"
          html += @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip
          html += "</td>"

          # Everything else center-aligned
          x = 2
          while (x <= data_table_config.columns)
            if ( y == 1 )
              colspan = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[0..2].gsub("#","")
              length = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.length
              @table_types[ data_table_config.table_name_id ][ y ][ x ] = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[3..length]
            else
              colspan = 1
            end
            html += "<td style='border: 1px solid grey; text-align: center;' colspan='" + colspan.to_s.strip + "'>"
            html += @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.strip
            x += colspan.to_i
            html += "</td>"
          end
        html += "</tr>"
      end
      html += "</table><p></p>"

      html.html_safe

    end

  end

end