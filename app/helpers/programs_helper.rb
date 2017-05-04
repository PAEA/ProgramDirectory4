module ProgramsHelper

  def display_fields_and_tables(f)

    if ( f.content_type == 'field' )
      ("<p>" + f.display_name.to_s.strip + " <i>" + f.field_value.to_s.strip + "</i></p>").html_safe
    elsif ( f.content_type == 'table' )
      if ( !f.display_name.to_s.strip.blank? )
        html = "<h3>" + f.display_name.to_s.strip + "</h3>"
      else
        html = ""
      end

      data_table_config = @data_table_configs.find_by_table_name_id(f.id)

      html += "<table style='border: 1px solid grey;'>"
      for y in 1..data_table_config.rows
        html += "<tr>"
          # Left-aligned text for categories, unless it's a checkmark
          if ( y == 1 )
            html += "<th "
          else
            html += "<td "
          end
          if ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.length == 1 || ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.include? "\u2713" ) )
            html += "class='subject subject-solo' style='border: 1px solid grey; text-align: center;'>"
          else
            html += "style='border: 1px solid grey; text-align: left;'>"
          end
          html += @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip
          if ( y == 1 )
            html += "</th>"
          else
            html += "</td>"
          end

          # Everything else center-aligned
          x = 2
          while (x <= data_table_config.columns)
            if ( y == 1 )
              colspan = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[0..2].gsub("#","")
              length = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.length
              @table_types[ data_table_config.table_name_id ][ y ][ x ] = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[3..length]
              html += "<th "
            else
              colspan = 1
              html += "<td "
            end
            html += "style='border: 1px solid grey; text-align: center;' colspan='" + colspan.to_s.strip + "'>"
            html += @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.strip
            x += colspan.to_i
            if ( y == 1 )
              html += "</th>"
            else
              html += "</td>"
            end
          end
        html += "</tr>"
      end
      html += "</table>"

      html.html_safe

    end

  end

end
