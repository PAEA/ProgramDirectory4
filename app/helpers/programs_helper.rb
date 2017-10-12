module ProgramsHelper

  def check_for_live_links(this_string, this_is_a_table_cell)
    if ( this_string.include? "http" )
      urls = this_string.split(/\s+/).find_all { |u| u =~ /^https?:/ }
      urls.each do |u|
        if ( this_is_a_table_cell )
          adding_linebreak = '<span class="small">' + u + '</span>'
        else
          adding_linebreak = u
        end
        this_string = this_string.sub( u, '<a href="' + u + '" target="_blank">' + adding_linebreak + '</a>' )
      end
    end
    return this_string
  end

  def display_fields_and_tables(f,can_edit)

    if ( f.content_type == 'field' && !f.field_value.to_s.strip.blank? )

      if ( can_edit )
        str = f.field_value.to_s.strip
        ("<label for='" + f.field_name + "' class='info-subhed' style='margin-bottom:0; margin-top: 8px;'>" + f.display_name.to_s.strip + "</label><input name='" + f.field_name + "' id='" + f.field_name + "' value='" + str + "' type='text' maxlength='" + f.field_size + "' style='width:100%;'><br/>").html_safe
      else
        str = check_for_live_links( f.field_value.to_s.strip, false )
        ("<p><span class='info-subhed'>" + f.display_name.to_s.strip + "</span> " + str + "</p>").html_safe
      end
    elsif ( f.content_type == 'table' )

      # table_empty applies in most cases to single row tables with no content.
      # If that is the case, thoe whole table gets hidden.
      table_empty = true

      if ( !f.display_name.to_s.strip.blank? )
        html = "<p>&nbsp;</p><h4>" + f.display_name.to_s.strip + "</h4>"
      else
        html = ""
      end

      data_table_config = @data_table_configs.find_by_table_name_id(f.id)

      table_has_categories = data_table_config.has_categories

      html += "<table>"
      for y in 1..data_table_config.rows
        # Left-aligned text for categories, unless it's a checkmark
        if ( y == 1 )
          html += "<thead><tr class='desktop-header'><th scope='row' "
        elsif ( y == 2 && @table_has_subheaders[ data_table_config.table_name_id ] )
            html += "<tr><th scope='row' "
        else
          header_first_row = @table_types[ data_table_config.table_name_id ][ 1 ][ 1 ].to_s
          html += "<tr><td data-label='" + header_first_row.gsub("#1#","") + "' "
        end
        if ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s[0] == "#")
          colspan = @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s[0..2].gsub("#","")
        else
          colspan = "1"
        end
        if ( colspan.to_i <= 1 )
          x = 2
          colspan = "1"
        else
          x = colspan.to_i + 1
          length = @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.length
          @table_types[ data_table_config.table_name_id ][ y ][ 1 ] = @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s[3..length]
        end
        if ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.length == 1 || ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.include? "\u2713" ) )
          html += ">"
        else

          # colspan for subsections within tables
          if ( table_has_categories )
            if ( colspan.to_i != 1 )
              html += "class='subject subject-solo' "
            else
              html += "class='subject subject-solo text-left' "
            end
          end
          html += "colspan='" + colspan.to_s.strip + "'>"
        end
        if ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.blank? )
          html += "&nbsp;"
        else
          html += @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.strip.gsub("#1#","")
        end
        if ( y == 1 || y == 2 && @table_has_subheaders[ data_table_config.table_name_id ] )
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
          elsif ( y == 2 && @table_has_subheaders[ data_table_config.table_name_id ] )
            colspan = 1
            html += "<th scope='row' "
          else
            if ( @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[0] != "#" || @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[2] != "#")
              colspan = 1
            else
              colspan = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[0..2].gsub("#","")
              length = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.length
              @table_types[ data_table_config.table_name_id ][ y ][ x ] = @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s[3..length]
            end

            header_first_row = @table_types[ data_table_config.table_name_id ][ 1 ][ x ].to_s
            if ( @table_has_subheaders[ data_table_config.table_name_id ] )
              subheader = @table_types[ data_table_config.table_name_id ][ 2 ][ x ].to_s
            else
              subheader = ""
            end
            if ( header_first_row.blank? )
              header_first_row = " > "
            #else
              #subheader = ": " + subheader
            end
            html += "<td data-label='" + header_first_row + subheader + "' "
          end

          if ( @table_types[ data_table_config.table_name_id ][ y ][ 1 ].to_s.include? "Notes" )
            alignment = "text-left"
          else
            alignment = "text-to-align"
          end
          html += "colspan='" + colspan.to_s.strip + "' class='" + alignment + "'>"
          if @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.strip.blank?
            html += "&nbsp;"
          else
            html += check_for_live_links( @table_types[ data_table_config.table_name_id ][ y ][ x ].to_s.strip, true )

            if ( y > 1 && !@table_types[ data_table_config.table_name_id ][ y ][ x ].blank? )
              table_empty = false
            end
          end
          x += colspan.to_i
          if ( y == 1 || y == 2 && @table_has_subheaders[ data_table_config.table_name_id ] )
            html += "</th>"
          else
            html += "</td>"
          end
        end
        if ( y == 1 && !@table_has_subheaders[ data_table_config.table_name_id ] || y == 2 && @table_has_subheaders[ data_table_config.table_name_id ] )
          html += "</tr></thead>"
        elsif ( y == 1 && @table_has_subheaders[ data_table_config.table_name_id ] )
          html += "</tr>"
        else
          html += "</tr>"
        end
      end
      html += "</table>"

      if ( table_empty )
        html = ""
      else
        html.html_safe
      end

    end

  end

end
