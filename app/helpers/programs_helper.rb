module ProgramsHelper

  def check_for_live_links(this_string, this_is_a_table_cell)
    if ( this_string.include? "http" )
      urls = this_string.split(/\s+/).find_all { |u| u =~ /^https?:/ }
      urls.each do |u|
        if this_is_a_table_cell
          adding_linebreak = '<span class="small">' + u + '</span>'
        else
          adding_linebreak = u
        end
        this_string = this_string.sub( u, '<a href="' + u + '" target="_blank">' + adding_linebreak + '</a>' )
      end
    end
    return this_string
  end

  def check_for_colspan( cell_value )
    if cell_value[0] != "#" || cell_value[2] != "#"
      return 1
    else
      return cell_value[0..2].gsub("#","").to_i
    end
  end

  def display_fields_and_tables(f,can_edit, can_approve, show_buttons)
    this_is_a = f.content_type
    id = f.id.to_s
    first_row = first_column = 1
    second_row = 2
    display_sections_id = f.display_sections_id
    display_name = f.display_name.to_s.strip
    old_value = f.field_value.to_s.strip
    new_value = f.field_value_temp.to_s.strip
    field_name = f.field_name
    field_size = f.field_size.to_s
    program_id = f.program_id.to_s

    if session[:user_role] == 'admin' && @mode == "edit"
      can_edit = (@fields_allowed_to_edit.include? display_sections_id)
    elsif session[:user_role] == 'admin' && @mode == "view"
      can_edit = false
    end

    # Form fields will be displayed if the user has edit role, or has approval role for changes submitted
    if this_is_a == 'field'

      # Field's default value = new value
      if can_edit
        if !new_value.blank?
          str = new_value
        else
          str = old_value
        end

        textarea_rows = [(field_size.to_i / 114).round, [(str.length / 114).round + 1, str.count(13.chr) + 1].max ].min
        ("<label for='" + field_name + "' class='info-subhed'>" + display_name + "</label><textarea name='" + field_name + "' id='" + field_name + "' rows=" + textarea_rows.to_s + " maxlength='" + field_size + "' style='width:100%;'>" + str + "</textarea><br/>").html_safe

      else

        if !old_value.blank? || !new_value.blank?
          str = check_for_live_links( old_value, false )
          str_temp = check_for_live_links( new_value, false )
          html = "<div id='current-" + id + "' class='add-bottom-margin'><span class='info-subhed'>" + display_name + "</span> "

          # if the field value is less than 100 chars, display it together with its field label
          # otherwise, use a <pre>-like display
          if str.length < 100 && str.count(13.chr) <= 1
            html += str + "</div>"
          else
            html += "<span class='pre'>" + str + "</span></div>"
          end

          if !new_value.blank? && show_buttons
            html += "<div id='new-" + id + "'><span class='info-subhed'>" + display_name + "</span><span class='pre add-bottom-margin'>" + str_temp + "</span></div>"
            html += "<div id='proposal-" + id + "' class='table-proposal pre'><div class='table-proposal-value'>" + new_value + "</div>"
            if can_approve
              html += "<div class='table-proposal-buttons'><button id='success-" + id + "' type='button' class='btn btn-success'><span class='glyphicon glyphicon-ok'></span></button> <button id='reject-" + id + "' type='button' class='btn btn-danger'><span class='glyphicon glyphicon-remove'></span></button></div>"
            end
            html += "</div>"
          end
          html.html_safe
        end

      end

    elsif this_is_a == 'table'

      # table_empty applies in most cases to single row tables with no content.
      # If that is the case, the whole table gets hidden.
      table_empty = true
      jquery = ""

      # In the spreadsheets, tables may have a title or not
      if !display_name.blank?
        html = "<p>&nbsp;</p><h4>" + display_name + "</h4>"
      else
        html = ""
      end

      # Get table configuration: how many rows, columns, does it have categories?, etc...
      # Each school may have different amount of rows from other schools for the same table
      data_table_config = @data_table_configs.find_by_table_name_id( id )

      # Check if the far left column are categories or just another data column
      table_has_categories = data_table_config.has_categories

      # Total rows for the table including header and subheader (if subheader applies)
      total_rows = data_table_config.rows

      table_name_id = data_table_config.table_name_id

      # If table has subheaders, then the first row will be left for the headers,
      # and the second row for the subheaders. After that comes the data.
      if @table_has_subheaders[ table_name_id ]
        table_has_subheaders = true
      else
        table_has_subheaders = false
      end

      # Build a string variable with all of the HTML code to display one table
      html += "<table>"

      for this_row in first_row..total_rows

        # Left-aligned text for categories, unless it's a checkmark
        if this_row == first_row
          # Display header row
          html += "<thead><tr class='desktop-header'><th scope='row' "
        elsif this_row == second_row && @table_has_subheaders[ table_name_id ]
            # Display subheader row
            html += "<tr><th scope='row' "
        else
          # Display data row
          if !@table_types[ table_name_id ][ first_row ][ first_column ].nil?
            header_first_row = @table_types[ table_name_id ][ first_row ][ first_column ][:value].to_s
            html += "<tr><td data-label='" + header_first_row.gsub("#1#","") + "' "
          else
            header_first_row = ""
            html += "<tr><td data-label='no_header' "
          end
        end

        # If the data cell needs to span multiple columns,
        # the cell value will start with #n#, where n is the number of columns it needs to span.
        # This is used mostly for Notes rows in tables which usually span multiple columns

        if !@table_types[ table_name_id ][ this_row ][ first_column ].nil? && @table_types[ table_name_id ][ this_row ][ first_column ][:value].to_s[0] == "#"
          # Get how many columns to span
          colspan = @table_types[ table_name_id ][ this_row ][ first_column ][:value].to_s[0..2].gsub("#","")
        else
          colspan = "1"
        end

        # Get cell value for this_row on first_column
        if !@table_types[ table_name_id ][ this_row ][ first_column ].nil?
          cell_value = @table_types[ table_name_id ][ this_row ][ first_column ][:value].to_s.strip
          cell_value_temp = @table_types[ table_name_id ][ this_row ][ first_column ][:temp_value].to_s.strip
        else
          cell_value = ""
        end
        cell_value_length = cell_value.length

        # x = get next column number after columns span
        if colspan == "1"
          x = 2
        else
          x = colspan.to_i + 1

          # Remove the "#n#" (colspan) string from the cell value in the first column
          @table_types[ table_name_id ][ this_row ][ first_column ][ :value ] = cell_value[3..cell_value_length]
          cell_value = @table_types[ table_name_id ][ this_row ][ first_column ][:value].to_s.strip

          cell_value_temp = @table_types[ table_name_id ][ this_row ][ first_column ][:temp_value].to_s.strip
          if cell_value_temp[0] == "#" and cell_value_temp[2] == "#"
            cell_value_temp_length = cell_value_temp.length
            @table_types[ table_name_id ][ this_row ][ first_column ][ :temp_value ] = cell_value_temp[3..cell_value_length]
            cell_value_temp = @table_types[ table_name_id ][ this_row ][ first_column ][:temp_value]
          end
        end

        # If the cell value is a checkmark or any other single character, close the <td> tag
        if cell_value_length == 1 || ( cell_value.include? "\u2713" )
          html += ">"
        else

          # colspan for subsections within tables
          if table_has_categories
            if colspan != "1"
              # Center text if it is a subcategory with colspan
              html += "class='subject subject-solo' "
            else
              # Left-align text otherwise
              html += "class='subject subject-solo text-left' "
            end
          end
          # Add colspan to the <td> tag
          html += "colspan='" + colspan.to_s + "'>"

        end

        if !@table_types[ table_name_id ][ this_row ][ 1 ].nil?
          field_name = "c" + @table_types[ table_name_id ][ this_row ][ 1 ][:id].to_s
        else
          field_name = "x" + rand(100000).to_s
        end
        field_size = 500

        if !can_edit && cell_value.blank?
          html += "&nbsp;"
        else
          # Cell's default value = new value
          if can_edit && !table_has_categories && ( this_row >= 2 && !table_has_subheaders || this_row >= 3 && table_has_subheaders )

            # If there is a temporary value, display that as the value to edit in the cell
            if ( !cell_value_temp.blank? )
              str = cell_value_temp
            else
              str = cell_value
            end
            if str == "\u2713" || ( str[0..1].include? "\u2713 " ) || ( str[0..1].include? "\u2713\n" ) || ( str[0..1].include? "\u2713\r" )
              # ascii checkmark symbol
              str = str.gsub("\u2713","x")
            end

            textarea_rows = [(str.length / (114 / data_table_config.columns) ).round + 1, str.count(13.chr) + 1].max
            html += "<textarea name='" + field_name + "' id='" + field_name + "' rows=" + textarea_rows.to_s + " maxlength='" + field_size.to_s + "' style='width:100%;'>" + str + "</textarea><br/>"

          elsif !table_has_categories && ( this_row >= 2 && !table_has_subheaders || this_row >= 3 && table_has_subheaders )

            #html += cell_value.gsub("#1#","")
            html += "<div id='current-" + field_name + "'><span class='pre-cell'>" + cell_value.gsub("#1#","") + "</span></div>"
            if !cell_value_temp.blank? && show_buttons

              if cell_value_temp == "x" || ( cell_value_temp[0..1].include? "x " ) || ( cell_value_temp[0..1].include? "x\n" ) || ( cell_value_temp[0..1].include? "x\r" )
                # ascii checkmark symbol
                str_display = cell_value_temp.gsub("x","\u2713")
              else
                str_display = cell_value_temp
              end
              html += "<div id='new-" + field_name + "'><span class='pre-cell'>" + check_for_live_links( str_display, true ) + "</span></div>"
              html += "<div id='proposal-" + field_name + "' class='table-proposal pre-cell'><div class='table-proposal-value'>" + check_for_live_links( str_display, true ) + "</div>"
              if can_approve
                html += "<div class='table-proposal-buttons'><button id='success-" + field_name + "' type='button' class='btn btn-success btn-sm'><span class='glyphicon glyphicon-ok'></span></button> <button id='reject-" + field_name + "' type='button' class='btn btn-danger btn-sm'><span class='glyphicon glyphicon-remove'></span></button></div>"
              end
              html += "</div>"
            end

            if cell_value != cell_value_temp && !cell_value_temp.blank? && show_buttons
              #html += "t:" + cell_value_temp.to_s
              #html += " <button id='success-" + id + "' type='button' class='btn btn-success btn-xs'><span class='glyphicon glyphicon-ok'></span></button> <button id='success-" + id + "' type='button' class='btn btn-success btn-xs'><span class='glyphicon glyphicon-remove'></span></button>"
              jquery += "$('#new-" + field_name + "').hide();"
              jquery += "$('#success-" + field_name + "').click(function(){ "
                jquery += "$('#current-" + field_name + "').hide();"
                jquery += "$('#proposal-" + field_name + "').hide();"
                if cell_value_temp != "(((DELETE)))"
                  jquery += "$('#new-" + field_name + "').fadeIn('slow');"
                else
                  jquery += "$('#new-" + field_name + "').hide();"
                end
                jquery += "$.ajax('/approve_change/" + program_id + "/" + @table_types[ table_name_id ][ this_row ][ 1 ][:id].to_s + "/cell');"
              jquery += "});"

              jquery += "$('#reject-" + field_name + "').click(function(){ "
                jquery += "$('#current-" + field_name + "').fadeIn('slow');"
                jquery += "$('#proposal-" + field_name + "').fadeOut('slow');"
                jquery += "$.ajax('/reject_change/" + program_id + "/" + @table_types[ table_name_id ][ this_row ][ 1 ][:id].to_s + "/cell');"
              jquery += "});"
            end

          else

            html += cell_value.gsub("#1#","")

          end
        end
        if this_row == first_row || this_row == second_row && @table_has_subheaders[ table_name_id ]
          html += "</th>"
        else
          html += "</td>"
        end

        # Data cells are center-aligned
        # Loop through the cell values of each column for each row
        while x <= data_table_config.columns
          if !@table_types[ table_name_id ][ this_row ][ x ].nil?
            cell_value = @table_types[ table_name_id ][ this_row ][ x ][:value].to_s.strip
            cell_value_temp = @table_types[ table_name_id ][ this_row ][ x ][:temp_value].to_s.strip
          else
            cell_value = ""
            cell_value_temp = ""
          end

          # If this is the table header row...
          if this_row == first_row

            # If the data cell needs to span multiple columns,
            # the cell value will start with #n#, where n is the number of columns it needs to span.
            # This is used mostly for Notes rows in tables which usually span multiple columns
            colspan = check_for_colspan( cell_value )
            length = cell_value.length

            # Remove #n# from the cell
            @table_types[ table_name_id ][ this_row ][ x ] = { :value => cell_value[3..length] }
            cell_value = @table_types[ table_name_id ][ this_row ][ x ][:value].to_s.strip

            # Open table header
            html += "<th scope='row' "
          elsif this_row == second_row && @table_has_subheaders[ table_name_id ]
            colspan = 1
            html += "<th scope='row' "
          else
            # If there is no #n# starting the cell value...
            colspan = check_for_colspan( cell_value )
            if colspan > 1
              # Otherwise get #n# for colspan
              length = cell_value.length
              # Remove #n# from cell
              #@table_types[ table_name_id ][ this_row ][ x ] = { :value => cell_value[3..length] }
              @table_types[ table_name_id ][ this_row ][ x ][ :value ] = cell_value[3..length]
              cell_value = @table_types[ table_name_id ][ this_row ][ x ][:value].to_s.strip
              if cell_value_temp[0] == "#" && cell_value_temp[2] == "#"
                cell_value_temp_length = cell_value_temp.length
                @table_types[ table_name_id ][ this_row ][ first_column ][ :temp_value ] = cell_value_temp[3..cell_value_temp_length]
                cell_value_temp = @table_types[ table_name_id ][ this_row ][ first_column ][:temp_value]
              end
            end

            header_first_row = cell_value

            if ( @table_has_subheaders[ table_name_id ] )
              subheader = @table_types[ table_name_id ][ second_row ][ x ][:value].to_s
            else
              subheader = ""
            end
            if header_first_row.blank?
              header_first_row = " > "
            end
            html += "<td data-label='" + header_first_row + subheader + "' "
          end

          if !@table_types[ table_name_id ][ this_row ][ first_column ].nil? && ( @table_types[ table_name_id ][ this_row ][ first_column ][:value].to_s.include? "Notes" )
            alignment = "text-left"
          else
            alignment = "text-to-align"
          end
          html += "colspan='" + colspan.to_s.strip + "' class='" + alignment + "'>"

          if !can_edit && cell_value.blank? && cell_value_temp.blank?
            html += "&nbsp;"
          else

            if !@table_types[ table_name_id ][ this_row ][ x ].nil?
              field_name = "c" + @table_types[ table_name_id ][ this_row ][ x ][:id].to_s
            else
              field_name = "x" + rand(100000).to_s
            end

            field_size = 500

            if can_edit && ( this_row >= 2 && !table_has_subheaders || this_row >= 3 && table_has_subheaders )

              # If there is a temporary value, display that as the value to edit in the cell
              if ( !cell_value_temp.blank? )
                str = cell_value_temp
              else
                str = cell_value
              end
              if str == "\u2713" || ( str[0..1].include? "\u2713 " ) || ( str[0..1].include? "\u2713\n" ) || ( str[0..1].include? "\u2713\r" )
                # ascii checkmark symbol
                str = str.gsub("\u2713","x")
              end

              textarea_rows = [(str.length / (114 / data_table_config.columns) ).round + 1, str.count(13.chr) + 1].max
              html += "<textarea name='" + field_name + "' id='" + field_name + "' rows=" + textarea_rows.to_s + " maxlength='" + field_size.to_s + "' style='width:100%;'>" + str + "</textarea><br/>"

            elsif this_row >= 2 && !table_has_subheaders || this_row >= 3 && table_has_subheaders

              #html += cell_value.gsub("#1#","")
              html += "<div id='current-" + field_name + "'><span class='pre-cell'>" + check_for_live_links( cell_value, true ) + "</span></div>"

              if !cell_value_temp.blank? && show_buttons

                if cell_value_temp == "x" || ( cell_value_temp[0..1].include? "x " ) || ( cell_value_temp[0..1].include? "x\n" ) || ( cell_value_temp[0..1].include? "x\r" )
                  # ascii checkmark symbol
                  str_display = cell_value_temp.gsub("x","\u2713")
                else
                  str_display = cell_value_temp
                end
                html += "<div id='new-" + field_name + "'><span class='pre-cell'>" + check_for_live_links( str_display, true ) + "</span></div>"
                html += "<div id='proposal-" + field_name + "' class='table-proposal pre-cell'><div class='table-proposal-value'>" + check_for_live_links( str_display, true ) + "</div>"
                if can_approve && show_buttons
                  html += "<div class='table-proposal-buttons'><button id='success-" + field_name + "' type='button' class='btn btn-success btn-sm'><span class='glyphicon glyphicon-ok'></span></button> <button id='reject-" + field_name + "' type='button' class='btn btn-danger btn-sm'><span class='glyphicon glyphicon-remove'></span></button></div>"
                end
                html += "</div>"
              end

              if cell_value != cell_value_temp && !cell_value_temp.blank? && show_buttons
                #html += "t:" + cell_value_temp.to_s
                #html += " <button id='success-" + id + "' type='button' class='btn btn-success btn-xs'><span class='glyphicon glyphicon-ok'></span></button> <button id='success-" + id + "' type='button' class='btn btn-success btn-xs'><span class='glyphicon glyphicon-remove'></span></button>"
                jquery += "$('#new-" + field_name + "').hide();"
                jquery += "$('#success-" + field_name + "').click(function(){ "
                  jquery += "$('#current-" + field_name + "').hide();"
                  jquery += "$('#proposal-" + field_name + "').hide();"
                  if cell_value_temp != "(((DELETE)))"
                    jquery += "$('#new-" + field_name + "').fadeIn('slow');"
                  else
                    jquery += "$('#new-" + field_name + "').hide();"
                  end
                  jquery += "$.ajax('/approve_change/" + program_id + "/" + @table_types[ table_name_id ][ this_row ][ x ][:id].to_s + "/cell');"
                jquery += "});"

                jquery += "$('#reject-" + field_name + "').click(function(){ "
                  jquery += "$('#current-" + field_name + "').fadeIn('slow');"
                  jquery += "$('#proposal-" + field_name + "').fadeOut('slow');"
                  jquery += "$.ajax('/reject_change/" + program_id + "/" + @table_types[ table_name_id ][ this_row ][ x ][:id].to_s + "/cell');"
                jquery += "});"

              end

              # Display row value
              #html += check_for_live_links( cell_value, true )
              #html += " t:" + cell_value_temp
              #if cell_value != cell_value_temp && !cell_value_temp.blank?
              #  html += " <button id='success-" + id + "' type='button' class='btn btn-success btn-xs'><span class='glyphicon glyphicon-ok'></span></button> <button id='reject-" + id + "' type='button' class='btn btn-danger btn-xs'><span class='glyphicon glyphicon-remove'></span></button>"
              #end

            else

              # Display header or subheader
              html += check_for_live_links( cell_value, true )

            end

            if this_row > first_row && !cell_value.blank?
              table_empty = false
            end
          end
          x += colspan

          if this_row == first_row || this_row == second_row && @table_has_subheaders[ table_name_id ]
            html += "</th>"
          else
            html += "</td>"
          end
        end
        if this_row == first_row && !@table_has_subheaders[ table_name_id ] || ( this_row == second_row && @table_has_subheaders[ table_name_id ] )
          html += "</tr></thead>"
        elsif this_row == first_row && @table_has_subheaders[ table_name_id ]
          html += "</tr>"
        else
          html += "</tr>"
        end
      end
      html += "</table>"

      # If the table has no data, don't display it
      if table_empty
        html = ""
      else
        html += "<script>$(document).ready(function(){ " + jquery + "}); </script>"
        html.html_safe
      end

    end

  end

end
