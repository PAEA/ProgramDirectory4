class ProgramsController < ApplicationController

  def index

    # Save today's date in a cookie so it won't show
    cookies[:adea_terms_accept] = Date.today
    @display_username = session[:display_username]
    @user_roles = session[:user_role]

    if @display_username.nil?
      redirect_to root_path
    end

    if session[:user_role] == 'admin'
      @id = (Program.find_by! program: session[:school_display]).id.to_s
    end

    @programs = Program.select_all_programs_sorted_alphabetically
    get_programs = Array.new
    @programs.each do |p|
      get_programs << p.id
    end

    # Get preselected filters - This comes from the metadata in the spreadsheets
    @filters = CustomFilter.select_all_filters_sorted_by_display_order

    $filter_values = Array.new

    # Fields to display right below the program name on the homepage or the results page
    card_fields = [ 'state_territory_province',
                    'type_of_institution',
                    'time_to_degree_in_months',
                    'start_month',
                    'doctoral_dental_degree_offered',
                    'campus_setting_urban',
                    'campus_housing_available' ]

    # Get card field values based on the card_fields array
    $get_card_fields = FieldsString.select_card_fields( card_fields.map{ |e| "'" + e + "'" }.join(', '), get_programs.join(', ') ).sort_by!  {|f| card_fields.index f[:field_name]}

    # Get all the possible options for each filter based on the field_name
    @filters.each do |this_filter|

      if ( this_filter.source == 'field' )
        filter_field = FieldName.find_by_field_name( this_filter.custom_filter )
        $filter_values << FieldsString.select_fields_by_filter( filter_field )
      elsif ( this_filter.source == 'table' )
        $filter_values << DataTable.select_tables_by_filter( this_filter.custom_filter )
      end

    end

  end

  def search

    @filters = CustomFilter.select_all_filters_sorted_by_display_order

    @display_username = session[:display_username]
    @user_roles = session[:user_role]

    if ( @display_username.nil? )
      redirect_to root_path
    end

    @programs = Program.select_all_programs_sorted_alphabetically
    get_programs = Array.new
    @programs.each do |p|
      get_programs << p.id
    end

    @values_to_search = Array.new
    @programs_search    = Array.new

    params.each do |p|

      @filters.each do |filter|
        if ( p == filter.custom_filter )
          if ( @values_to_search[ @filters.index(filter) ].nil? )
            @values_to_search[ @filters.index(filter) ] = params[p].map { |checkbox_value| "'#{checkbox_value}'" }.join(', ')
          end
        end
      end

    end

    if ( !params['keywords'].blank? )

      keywords_array = params['keywords'].split(",").map{ |keyword| keyword.downcase.strip }
      where_condition = ""
      where_condition_for_programs = ""
      where_condition_for_tables = ""
      where_values = Array.new

      keywords_array.each_with_index do |keyword, index|
        if ( index == 0 )
          where_condition << "lower(field_value) LIKE ?"
          where_condition_for_programs << "lower(program) LIKE ?"
          where_condition_for_tables << "lower(cell_value) LIKE ?"
          where_values << "%#{keyword}%"
        else
          where_condition << " OR lower(field_value) LIKE ?"
          where_condition_for_programs << " OR lower(program) LIKE ?"
          where_condition_for_tables << " OR lower(cell_value) LIKE ?"
          where_values << "%#{keyword}%"
        end
      end

      search_query = [ where_condition ] + where_values
      search_query_programs = [ where_condition_for_programs ] + where_values
      search_query_tables = [ where_condition_for_tables ] + where_values

      programs_search_string  = FieldsString.select_fields_by_keywords( search_query )
      programs_search_text    = FieldsText.select_fields_by_keywords( search_query )
      programs_search_integer = FieldsInteger.select_fields_by_keywords( search_query )
      programs_search_decimal = FieldsDecimal.select_fields_by_keywords( search_query )
      programs_search_tables  = DataTable.select_fields_by_keywords( search_query_tables )
      programs_search_name    = Program.select_fields_by_keywords( search_query_programs )

      programs_array = Array.new
      programs_search_string.each do |ps|
        programs_array << ps.program_id
      end
      programs_search_text.each do |ps|
        programs_array << ps.program_id
      end
      programs_search_integer.each do |ps|
        programs_array << ps.program_id
      end
      programs_search_decimal.each do |ps|
        programs_array << ps.program_id
      end
      programs_search_tables.each do |ps|
        programs_array << ps.program_id
      end
      programs_search_name.each do |ps|
        programs_array << ps.id
      end
      get_programs = get_programs & programs_array.uniq

    end

    @values_to_search.each do |these_values|
      if ( !these_values.nil? )

        index = @values_to_search.index(these_values)

        if ( @filters[index].source == 'field' )
          get_programs_query = FieldsString.select_programs_by_filter_value( @filters[index].custom_filter, these_values )
        elsif ( @filters[index].source == 'table' )
          get_programs_query = Program.select_programs_by_filter_value( @filters[index].custom_filter, these_values )
        end
        programs_array = Array.new
        get_programs_query.each do |p|
          programs_array << p.program_id
        end

        get_programs = get_programs & programs_array
      end
    end

    @programs = Program.select_programs_sorted_alphabetically( get_programs )

  end

  def save_changes
    fields_allowed_to_edit = Array.new
    form_fields = Array.new
    form_cells = Array.new

    # If the user's school = school page to view
    puts session[:user_role].inspect

    if session[:user_role] == 'admin' && !(@fields = SettingsField.get_editing_fields( session[:user_role_id] )).nil?
      @fields.each do |this_field|
        fields_allowed_to_edit << this_field.display_sections_id
      end
    end

    id = params[:id].to_i

    @fields_to_display = FieldName.select_fields_to_display( id )

    @fields_to_display.each do |f|
      this_field = Array.new

      # Save current values for all fields. This value will be compared against the form
      # values after saving. If they are different, they get saved as "temp" values in each
      # table. These new values need to get approved before displaying on the webpage.
      this_field[0] = id                       # field program id
      this_field[1] = f.id                      # field id
      this_field[2] = f.field_name              # field name
      this_field[3] = f.field_value.to_s.strip  # field original value
      this_field[4] = f.content_type            # field or table cell
      this_field[5] = f.field_type              # string, text, decimal or integer
      this_field[6] = f.display_sections_id     # Display Section id (table)

      form_fields << this_field
    end

    # For each field that has been changed, save the new value as a temporary value.
    # The comparisson process is done between the field's current value vs the submitted form field value
    form_fields.each do |field|

      if ( session[:user_role] == 'admin' && ( fields_allowed_to_edit.include? field[6] )) || session[:user_role] == 'editor'
        program_id = field[0]
        field_id = field[1]
        field_new_value = params[field[2].to_sym].to_s.strip.delete("\u000A")
        field_old_value = field[3].to_s.strip.delete("\u000A")
        content_type = field[4]
        field_type = field[5]

        if content_type == 'field' && field_old_value != field_new_value && !field_new_value.nil?

          # In case the new value is blank, meaning it was removed
          if field_new_value.blank?
            field_new_value = "(((DELETED)))"
          end

          # Save the new value as a temporary value depending on the data type of the field
          if field_type == "string"
            FieldsString.where(program_id: program_id, field_id: field_id).update(:field_value_temp => field_new_value)
          elsif field_type == "text"
            FieldsText.where(program_id: program_id, field_id: field_id).update(:field_value_temp => field_new_value)
          elsif field_type == "integer"
            FieldsInteger.where(program_id: program_id, field_id: field_id).update(:field_value_temp => field_new_value.to_i)
          elsif field_type == "decimal"
            FieldDecimal.where(program_id: program_id, field_id: field_id).update(:field_value_temp => field_new_value.to_f)
          end

        elsif content_type == 'field' && field_old_value == field_new_value

          if field_type == "string"
            FieldsString.where(program_id: program_id, field_id: field_id).update(:field_value_temp => nil)
          elsif field_type == "text"
            FieldsText.where(program_id: program_id, field_id: field_id).update(:field_value_temp => nil)
          elsif field_type == "integer"
            FieldsInteger.where(program_id: program_id, field_id: field_id).update(:field_value_temp => nil)
          elsif field_type == "decimal"
            FieldDecimal.where(program_id: program_id, field_id: field_id).update(:field_value_temp => nil)
          end

        end

      end

    end

    # Get all of the table configurations (title, number of rows and columns)
    data_table_configs = DataTableConfig.select_tables_by_program_id( id )

    # Create array containing headers, subheaders, categories and data for each table
    data_table_configs.each do |table_configuration|

      data_table = DataTable.select_table_config_by_program_id( id, table_configuration.id )
      data_table.each do |cell|
        this_cell = Array.new

        # Save current values for all table cells. This value will be compared against the form
        # values after saving. If they are different, they get saved as "temp" values in each
        # table. These new values need to get approved before displaying on the webpage.
        this_cell[0] = cell.id                         # table cell id
        this_cell[1] = cell.cell_value.to_s.strip      # table cell original value
        this_cell[2] = cell.cell_value_temp.to_s.strip # table cell temporary value
        this_cell[3] = cell.program_id                 # program_id

        form_cells << this_cell

      end
    end

    # For each table cell that has been changed, save the new value as a temporary value.
    # The comparisson process is done between the cell's current value vs the submitted form field value

    form_cells.each do |cell|

      cell_id = cell[0]
      cell_old_value = cell[1].to_s.strip.delete("\u000A")
      cell_new_value = params[("c"+cell[0].to_s).to_sym].to_s.strip.delete("\u000A")

      program_id = cell[3]

      if cell_old_value != cell_new_value && !cell_new_value.nil?

        # In case the new value is blank, meaning it was removed
        #if cell_new_value.blank?
        #  cell_new_value = "(((DELETED)))"
        #end

        # Save the new value as a temporary value
        DataTable.where(id: cell_id).update(:cell_value_temp => cell_new_value)

        # Add a log entry
        #new_log_entry = Log.create(
        #  program_id: program_id,
        #  field_id: cell_id,
        #  old_value: cell_old_value,
        #  new_value: cell_new_value,
        #  user_id: 1
        #)

      elsif cell_old_value == cell_new_value

        DataTable.where(id: cell_id).update(:cell_value_temp => nil)

      end

    end

    get_school_name = Program.find( id )
    school = [id.to_s, get_school_name.program.parameterize].join("-")
    redirect_to "/information/" + school

  end

  def approve_change

    program_id = params[:program_id].to_s
    field_id =  params[:field_id].to_s
    field_type = params[:field_type].to_s

    if field_type == "string"
      FieldsString.where(program_id: program_id, field_id: field_id, field_value_temp: "(((DELETED)))" ).update_all("field_value_temp = null")
      FieldsString.where(program_id: program_id, field_id: field_id).update_all("field_value = field_value_temp, field_value_temp = null")
    elsif field_type == "text"
      FieldsText.where(program_id: program_id, field_id: field_id, field_value_temp: "(((DELETED)))" ).update_all("field_value_temp = null")
      FieldsText.where(program_id: program_id, field_id: field_id).update_all("field_value = field_value_temp, field_value_temp = null")
    elsif field_type == "integer"
      FieldsInteger.where(program_id: program_id, field_id: field_id).update_all("field_value = field_value_temp, field_value_temp = null")
    elsif field_type == "decimal"
      FieldsDecimal.where(program_id: program_id, field_id: field_id).update_all("field_value = field_value_temp, field_value_temp = null")
    elsif field_type == "cell"
      DataTable.where(id: field_id, cell_value_temp: "(((DELETED)))" ).update_all("cell_value_temp = null")
      DataTable.where(id: field_id).update_all("cell_value = cell_value_temp, cell_value_temp = null")
    end

  end

  def reject_change

    program_id = params[:program_id].to_s
    field_id =  params[:field_id].to_s
    field_type = params[:field_type].to_s

    if field_type == "string"
      FieldsString.where(program_id: program_id, field_id: field_id).update_all("field_value_temp = null")
    elsif field_type == "text"
      FieldsText.where(program_id: program_id, field_id: field_id).update_all("field_value_temp = null")
    elsif field_type == "integer"
      FieldsInteger.where(program_id: program_id, field_id: field_id).update_all("field_value_temp = null")
    elsif field_type == "decimal"
      FieldsDecimal.where(program_id: program_id, field_id: field_id).update_all("field_value_temp = null")
    elsif field_type == "cell"
      DataTable.where(id: field_id).update_all("cell_value_temp = null")
    end

  end

  # Returns boolean value for this_var
  #def to_boolean(this_var)

    #this_var == "true"

  #end

  def information
    form_cells = Array.new
    @show_buttons = false

    @display_username = session[:display_username]
    # If the user has not logged in...
    if ( @display_username.nil? )
      redirect_to root_path
    end
    @fields_allowed_to_edit = Array.new
    @user_roles = session[:user_role]
    this_field = Array.new

    @id = params[:id].to_i
    school = params[:id].to_s

    # If the user's school = school page to view
    if session[:user_role] == 'admin'
      if school == [@id.to_s, session[:school].parameterize].join("-")
        if params.has_key?(:mode)
          # Editing conditional to URL parameter ("edit" or "view" values)
          @edit = (params[:mode] == "edit")
          @mode = params[:mode]
        else
          # Edit by role default
          @edit = true
          @mode = "edit"
        end
        @show_buttons = true
      else
        @edit = false
        @show_buttons = false
        @mode = "view"
      end
      @approve = false

      if !(@fields = SettingsField.get_editing_fields( session[:user_role_id] )).nil?
        @fields.each do |this_field|
          @fields_allowed_to_edit << this_field.display_sections_id
        end
      end
    elsif session[:user_role] == 'editor'
      if params.has_key?(:mode)
        @edit = (params[:mode] == "edit")
      else
        @edit = true
      end
      @approve = true
      @show_buttons = true
    end

    @program = Program.find(@id)
    @field_string = FieldsString.find_by_program_id(@id)

    @fields_to_display = FieldName.select_fields_to_display( @id )

    @fields_to_display.each do |f|
      this_field = Array.new

      # Save current values for all fields. This value will be compared against the form
      # values after saving. If they are different, they get saved as "temp" values in each
      # table. These new values need to get approved before displaying on the webpage.
      this_field[0] = @id                       # field program id
      this_field[1] = f.id                      # field id
      this_field[2] = f.field_name              # field name
      this_field[3] = f.field_value.to_s.strip  # field original value
      this_field[4] = f.content_type            # field or table cell
      this_field[5] = f.field_type              # string, text, decimal or integer
      this_field[6] = f.display_sections_id     # Display Section id (table)

    end

    # Get all of the table configurations (title, number of rows and columns)
    @data_table_configs = DataTableConfig.select_tables_by_program_id( @id )

    # Get how many table configurations
    table_types_amount = @data_table_configs.count
    @table_types = Array.new( table_types_amount + 1 )
    @table_names = Array.new( table_types_amount + 1 )
    @table_has_subheaders = Array.new( table_types_amount + 1 )

    # Create array containing headers, subheaders, categories and data for each table
    @data_table_configs.each do |table_configuration|

      first_data_row = 0
      this_row = table_configuration.rows
      this_column_subheader = 1
      table_name = table_configuration.table_name_id

      # +1 since arrays start in 0
      @table = Array.new( table_configuration.rows + 1 ) { Array.new( table_configuration.columns + 1) }

      data_table = DataTable.select_table_config_by_program_id( @id, table_configuration.id )
      data_table.each do |cell|
        this_cell = Array.new

        # Save current values for all table cells. This value will be compared against the form
        # values after saving. If they are different, they get saved as "temp" values in each
        # table. These new values need to get approved before displaying on the webpage.
        this_cell[0] = cell.id                         # table cell id
        this_cell[1] = cell.cell_value.to_s.strip      # table cell original value
        this_cell[2] = cell.cell_value_temp.to_s.strip # table cell temporary value
        this_cell[3] = cell.program_id                 # program_id

        form_cells << this_cell

        # Get the number of the first data row
        if (first_data_row == 0)
          first_data_row = cell.cell_row
        end

        # Fills each table type with its cell values per row and column
        if ( this_cell[1] == "x" || ( this_cell[1][0..1].include? "x ") || ( this_cell[1][0..1].include? "x\n") || ( this_cell[1][0..1].include? "x\r") )
          # ascii checkmark symbol
          @table[ cell.cell_row ][ cell.cell_column ] = { :value => this_cell[1].gsub("x","\u2713"), :temp_value => this_cell[2], :id => this_cell[0] }
        else
          @table[ cell.cell_row ][ cell.cell_column ] = { :value => this_cell[1], :temp_value => this_cell[2], :id => this_cell[0] }
        end

      end

      # Add categories to the table from the bottom up, if exist
      if ( table_configuration.has_categories )
        categories = Category.select_categories_by_table_config_id( table_configuration.id )
        categories.each do |category|
          if ( category.category.to_s == "x" || ( category.category.to_s[0..1].include? "x " ) || ( category.category.to_s[0..1].include? "x\n") || ( category.category.to_s[0..1].include? "x\r") )
            # ascii checkmark symbol
            @table[ this_row ][ 1 ] = { :value => category.category.to_s.gsub("x","\u2713"), :temp_value => nil, :id => category.id }
          else
            @table[ this_row ][ 1 ] = { :value => category.category, :temp_value => nil, :id => category.id }
          end
          this_row -= 1
        end
      end

      # Add subheaders to the table from right to left (if the table has subheaders)
      # row 1 = header, row 2 = subheader
      # If first_data_row = 2 there are no subheaders for the table, just a header
      duplicate_subheaders = false
      if ( first_data_row == 3 )
        subheaders = SubHeader.select_subheaders_by_table_name_id( table_configuration.table_name_id )

        # -1 because it needs to exclude the categories subheader
        if ( table_configuration.has_categories )
          amount_of_subheaders = subheaders.count - 1
        else
          amount_of_subheaders = subheaders.count
        end

        if ( amount_of_subheaders > 0 )
          table_has_subheaders = true

          # If the amount of subheaders (minus the category subheader) mod 2 = 0 then
          # all the subheaders need to get duplicated as a comparison table
          if ( table_configuration.has_categories )
            if ( ( table_configuration.columns - 1 ) % 2 == 0 )
              duplicate_subheaders = true
            end
          else
            if ( table_configuration.columns % 2 == 0 )
              duplicate_subheaders = true
            end
          end

          subheaders.each do |subheader|
            @table[ 2 ][ this_column_subheader ] = { :value => subheader.subheader, :temp_value => nil, :id => subheader.id }

            # Subheaders duplication will happen at current column number + amount_of_subheaders
            if ( duplicate_subheaders && this_column_subheader >= 2 || duplicate_subheaders && this_column_subheader >= 1 && !table_configuration.has_categories )
              @table[ 2 ][ this_column_subheader + amount_of_subheaders ] = { :value => subheader.subheader, :temp_value => nil, :id => subheader.id }
            end
            this_column_subheader += 1
          end
        else
          table_has_subheaders = false
        end
      end

      headers = MainHeader.select_headers_by_table_name_id( table_configuration.table_name_id )
      amount_of_headers = headers.count

      # Standard table headers start at column 1,
      # if subheaders exist, then headers start at column 2
      if ( duplicate_subheaders )
        column_increment = amount_of_subheaders
        if ( table_configuration.has_categories )
          this_column_header = 2
        else
          this_column_header = 1
        end
      else
        column_increment = 1
        this_column_header = 1
      end

      headers.each do |header|

        # Adds a column span number between hashes for column >= 2 when categories are present
        # or for tables without categories
        if ( this_column_header >= 2 && table_configuration.has_categories ) || ( this_column_header >= 1 && !table_configuration.has_categories )

          #if @table[ 1 ][ this_column_header ].has_key?("value")
            new_value = "#" + column_increment.to_s + "#" + header.header.to_s.strip
          #else
            #new_value = ""
          #end
          @table[ 1 ][ this_column_header ] = { :value => new_value, :temp_value => nil, :id => header.id }

        else

          @table[ 1 ][ this_column_header ] = { :value => header.header.to_s, :temp_value => nil, :id => header.id }

        end

        this_column_header += column_increment

      end

      # Get table name
      table_title = TableName.find( table_configuration.table_name_id )

      @table_types[ table_configuration.table_name_id ] = @table
      @table_names[ table_configuration.table_name_id ] = table_title.display_table_name
      @table_has_subheaders[ table_configuration.table_name_id ] = table_has_subheaders
    end

  end

end
