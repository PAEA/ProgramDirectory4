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
    old_value = f.field_value.to_s.strip
    new_value = f.field_value_temp.to_s.strip
    field_name = f.field_name
    display_name = f.display_name.to_s.strip
    field_size = f.field_size.to_s
    id = f.id.to_s
    first_row = first_column = 1
    second_row = 2
    this_is_a = f.content_type

    # Form fields will be displayed if the user has edit role, or has approval role for changes submitted
    if this_is_a == 'field'

      # Field's default value = new value
      if ( can_edit )
        if ( !new_value.blank? )
          str = new_value
        else
          str = old_value
        end

        #if ( str.length < 100 )
        #  ("<label for='" + field_name + "' class='info-subhed'>" + display_name + "</label><input name='" + field_name + "' id='" + field_name + "' value='" + str + "' type='text' maxlength='" + field_size + "' style='width:100%;'><br/>").html_safe
      #  else
          # For display purposes, calculate how many rows the textarea should show based on the field's max length or the amount of line feeds it has
          textarea_rows = [(field_size.to_i / 114).round, [(str.length / 114).round + 1, str.count(13.chr) + 1].max ].min
          ("<label for='" + field_name + "' class='info-subhed'>" + display_name + "</label><textarea name='" + field_name + "' id='" + field_name + "' rows=" + textarea_rows.to_s + " maxlength='" + field_size + "' style='width:100%;'>" + str + "</textarea><br/>").html_safe
      #  end
      else
        if !old_value.blank? || !new_value.blank?
          str = check_for_live_links( old_value, false )
          str_temp = check_for_live_links( new_value, false )
          html = "<div id='current-" + id + "' class='add-bottom-margin'><span class='info-subhed'>" + display_name + "</span> "

          # if the field value is less than 100 chars, display it together with its field label
          # otherwise, use a <pre>-like display
          if ( str.length < 100 && str.count(13.chr).zero? )
            html += str + "</div>"
          else
            html += "<span class='pre'>" + str + "</span></div>"
          end

          if ( !new_value.blank? )
            html += "<div id='new-" + id + "'><span class='info-subhed'>" + display_name + "</span><span class='pre add-bottom-margin'>" + str_temp + "</span></div>"
            html += "<div id='proposal-" + id + "' class='table-proposal pre'><div class='table-proposal-value'>" + new_value + "</div><div class='table-proposal-buttons'><button id='success-" + id + "' type='button' class='btn btn-success'><span class='glyphicon glyphicon-ok'></span></button> <button id='reject-" + id + "' type='button' class='btn btn-danger'><span class='glyphicon glyphicon-remove'></span></button></div></div>"
          end
          html.html_safe
        end
      end

    elsif ( this_is_a == 'table' )

      # table_empty applies in most cases to single row tables with no content.
      # If that is the case, thoe whole table gets hidden.
      table_empty = true

      if ( !display_name.blank? )
        html = "<p>&nbsp;</p><h4>" + display_name + "</h4>"
      else
        html = ""
      end

      data_table_config = @data_table_configs.find_by_table_name_id( id )

      table_has_categories = data_table_config.has_categories
      total_rows = data_table_config.rows
      table_name_id = data_table_config.table_name_id

      html += "<table>"
      for this_row in first_row..total_rows

        # Left-aligned text for categories, unless it's a checkmark
        if ( this_row == first_row )
          html += "<thead><tr class='desktop-header'><th scope='row' "
        elsif ( this_row == second_row && @table_has_subheaders[ table_name_id ] )
            html += "<tr><th scope='row' "
        else
          header_first_row = @table_types[ table_name_id ][ first_row ][ first_column ].to_s
          html += "<tr><td data-label='" + header_first_row.gsub("#1#","") + "' "
        end
        if ( @table_types[ table_name_id ][ this_row ][ first_column ].to_s[0] == "#")
          colspan = @table_types[ table_name_id ][ this_row ][ first_column ].to_s[0..2].gsub("#","")
        else
          colspan = "1"
        end
        if ( colspan.to_i <= 1 )
          x = 2
          colspan = "1"
        else
          x = colspan.to_i + 1
          length = @table_types[ table_name_id ][ this_row ][ first_column ].to_s.length
          @table_types[ table_name_id ][ this_row ][ first_column ] = @table_types[ table_name_id ][ this_row ][ first_column ].to_s[3..length]
        end
        if ( @table_types[ table_name_id ][ this_row ][ first_column ].to_s.strip.length == 1 || ( @table_types[ table_name_id ][ this_row ][ first_column ].to_s.strip.include? "\u2713" ) )
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
          html += "colspan='" + colspan.to_s + "'>"
        end
        if ( @table_types[ table_name_id ][ this_row ][ first_column ].to_s.strip.blank? )
          html += "&nbsp;"
        else
          html += @table_types[ table_name_id ][ this_row ][ first_column ].to_s.strip.gsub("#1#","")
        end
        if ( this_row == first_row || this_row == second_row && @table_has_subheaders[ table_name_id ] )
          html += "</th>"
        else
          html += "</td>"
        end

        # Everything else center-aligned
        while (x <= data_table_config.columns)
          if ( this_row == first_row )
            colspan = @table_types[ table_name_id ][ this_row ][ x ].to_s[0..2].gsub("#","")
            length = @table_types[ table_name_id ][ this_row ][ x ].to_s.length
            @table_types[ table_name_id ][ this_row ][ x ] = @table_types[ table_name_id ][ this_row ][ x ].to_s[3..length]
            html += "<th scope='row' "
          elsif ( this_row == second_row && @table_has_subheaders[ table_name_id ] )
            colspan = 1
            html += "<th scope='row' "
          else
            if ( @table_types[ table_name_id ][ this_row ][ x ].to_s[0] != "#" || @table_types[ table_name_id ][ this_row ][ x ].to_s[2] != "#")
              colspan = 1
            else
              colspan = @table_types[ table_name_id ][ this_row ][ x ].to_s[0..2].gsub("#","")
              length = @table_types[ table_name_id ][ this_row ][ x ].to_s.length
              @table_types[ table_name_id ][ this_row ][ x ] = @table_types[ table_name_id ][ this_row ][ x ].to_s[3..length]
            end

            header_first_row = @table_types[ table_name_id ][ first_row ][ x ].to_s
            if ( @table_has_subheaders[ table_name_id ] )
              subheader = @table_types[ table_name_id ][ second_row ][ x ].to_s
            else
              subheader = ""
            end
            if ( header_first_row.blank? )
              header_first_row = " > "
            end
            html += "<td data-label='" + header_first_row + subheader + "' "
          end

          if ( @table_types[ table_name_id ][ this_row ][ first_column ].to_s.include? "Notes" )
            alignment = "text-left"
          else
            alignment = "text-to-align"
          end
          html += "colspan='" + colspan.to_s.strip + "' class='" + alignment + "'>"
          if @table_types[ table_name_id ][ this_row ][ x ].to_s.strip.blank?
            html += "&nbsp;"
          else
            html += check_for_live_links( @table_types[ table_name_id ][ this_row ][ x ].to_s.strip, true )

            if ( this_row > first_row && !@table_types[ table_name_id ][ this_row ][ x ].blank? )
              table_empty = false
            end
          end
          x += colspan.to_i
          if ( this_row == first_row || this_row == second_row && @table_has_subheaders[ table_name_id ] )
            html += "</th>"
          else
            html += "</td>"
          end
        end
        if ( this_row == first_row && !@table_has_subheaders[ table_name_id ] || this_row == second_row && @table_has_subheaders[ table_name_id ] )
          html += "</tr></thead>"
        elsif ( this_row == first_row && @table_has_subheaders[ table_name_id ] )
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
