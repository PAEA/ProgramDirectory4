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

      html += "<table>"
      for y in 1..data_table_config.rows
        # Left-aligned text for categories, unless it's a checkmark
        if ( y == 1 )
          html += "<thead><tr><th scope='row' "
        else
          header_first_row = @table_types[ data_table_config.table_name_id ][ 1 ][ 1 ].to_s
          html += "<tr><td data-label='" + header_first_row + "' "
        end
        colspan = @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s[0..2].gsub("#","")
        if ( colspan.to_i <= 1 )
          x = 2
        else
          x = colspan.to_i + 1
          length = @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.length
          @table_types[ data_table_config.table_name_id ][ y ][ 1 ] = @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s[3..length]
        end
        if ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.length == 1 || ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.include? "\u2713" ) )
          html += "style='border: 1px solid grey;'>"
        else

          # colspan for subsections within tables
          html += "class='subject subject-solo' style='border: 1px solid grey;' colspan='" + colspan.to_s.strip + "'>"
        end
        if @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.blank?
          html += "&nbsp;"
        else
          html += @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip
        end
        if ( y == 1 )
          html += "</th>"
        else
          html += "</td>"
        end

        # Everything else center-aligned
        while (x <= data_table_config.columns)
          if ( y == 1 )
            colspan = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[0..2].gsub("#","")
            length = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.length
            @table_types[ data_table_config.table_name_id ][ y ][ x ] = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[3..length]
            html += "<th scope='row' "
          else
            colspan = 1
            header_first_row = @table_types[ data_table_config.table_name_id ][ 1 ][ x ].to_s
            html += "<td data-label='" + header_first_row + "' "
          end
          html += "style='border: 1px solid grey;' colspan='" + colspan.to_s.strip + "'>"
          if @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.strip.blank?
            html += "&nbsp;"
          else
            html += @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.strip
          end
          x += colspan.to_i
          if ( y == 1 )
            html += "</th>"
          else
            html += "</td>"
          end
        end
        if ( y == 1 )
          html += "</tr></thead>"
        else
          html += "</tr>"
        end
      end
      html += "</table>"

      html.html_safe

    end

  end

end
