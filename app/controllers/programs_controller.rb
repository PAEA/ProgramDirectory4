class ProgramsController < ApplicationController

  def index

    @display_username = session[:display_username]
    @user_roles = session[:user_roles]

    if ( @display_username.nil? )
      redirect_to root_path
    end

    @programs = Program.select_all_programs_sorted_alphabetically
    get_programs = Array.new
    @programs.each do |p|
      get_programs << p.id
    end

    # Fields to display right below the program name on the homepage or the results page
    card_fields = [ 'state_territory_province', 'type_of_institution', 'time_to_degree_in_months', 'start_month', 'doctoral_dental_degree_offered', 'campus_setting_urban', 'campus_housing_available' ]

    # Get card field values based on the card_fields array
    $get_card_fields = FieldsString.select_card_fields( card_fields.map{ |e| "'" + e + "'" }.join(', '), get_programs.join(', ') ).sort_by!  {|f| card_fields.index f[:field_name]}

    # Get all the possible options for each filter based on the field_name
    filter_field = FieldName.find_by_field_name('type_of_institution')
    $filter_1_values = FieldsString.select_fields_by_filter( filter_field )

    $filter_2_values = DataTable.select_tables_by_filter('residency_requirements')

    filter_field = FieldName.find_by_field_name('predental_programs')
    $filter_3_values = FieldsString.select_fields_by_filter( filter_field )

    filter_field = FieldName.find_by_field_name('state_territory_province')
    $filter_4_values = FieldsString.select_fields_by_filter( filter_field )

    filter_field = FieldName.find_by_field_name('doctoral_dental_degree_offered')
    $filter_5_values = FieldsString.select_fields_by_filter( filter_field )

  end

  def search

    @display_username = session[:display_username]
    @user_roles = session[:user_roles]

    if ( @display_username.nil? )
      redirect_to root_path
    end

    @programs = Program.select_all_programs_sorted_alphabetically
    get_programs = Array.new
    @programs.each do |p|
      get_programs << p.id
    end

    @values_to_search_1 = Array.new
    @values_to_search_2 = Array.new
    @values_to_search_3 = Array.new
    @values_to_search_4 = Array.new
    @values_to_search_5 = Array.new
    @programs_search    = Array.new

    params.each do |p|
      if ( params[p] == "1" )
        @values_to_search_1 << p
      elsif ( params[p] == "2" )
        @values_to_search_2 << p
      elsif ( params[p] == "3" )
        @values_to_search_3 << p
      elsif ( params[p] == "4" )
        @values_to_search_4 << p
      elsif ( params[p] == "5" )
        @values_to_search_5 << p
      elsif ( p == "q" && !params['q'].blank? )

        keywords_array = params['q'].split(",").map{ |e| e.strip }
        where_condition = ""
        where_values = Array.new
        keywords_array.each_with_index do |keyword, index|
          if ( index == 0 )
            where_condition << "field_value LIKE ?"
            where_values << "%#{keyword}%"
          else
            where_condition << " OR field_value LIKE ?"
            where_values << "%#{keyword}%"
          end
        end

        search_query = [ where_condition ] + where_values

        programs_search = FieldsString.select_fields_by_keywords( search_query )

        programs_array = Array.new
        programs_search.each do |ps|
          programs_array << ps.program_id
        end
        get_programs = get_programs & programs_array

        puts get_programs

      end
    end

    if ( !@values_to_search_1.empty? )
      these_values = @values_to_search_1.map{ |e| "'" + e + "'" }.join(', ')
      get_programs_query = FieldsString.select_programs_by_filter_value( "type_of_institution", these_values )

      programs_array = Array.new
      get_programs_query.each do |p|
        programs_array << p.program_id
      end

      get_programs = get_programs & programs_array

    end

    if ( !@values_to_search_2.empty? )
      these_values = @values_to_search_2.map{ |e| "'" + e + "'" }.join(', ')
      get_programs_query = Program.select_programs_by_filter_value( "residency_requirements", these_values )

      programs_array = Array.new
      get_programs_query.each do |p|
        programs_array << p.id
      end
      get_programs = get_programs & programs_array

    end

    if ( !@values_to_search_3.empty? )
      these_values = @values_to_search_3.map{ |e| "'" + e + "'" }.join(', ')
      get_programs_query = FieldsString.select_programs_by_filter_value( "predental_programs", these_values )

      programs_array = Array.new
      get_programs_query.each do |p|
        programs_array << p.program_id
      end
      get_programs = get_programs & programs_array

    end

    if ( !@values_to_search_4.empty? )
      these_values = @values_to_search_4.map{ |e| "'" + e + "'" }.join(', ')
      get_programs_query = FieldsString.select_programs_by_filter_value( "state_territory_province", these_values )

      programs_array = Array.new
      get_programs_query.each do |p|
        programs_array << p.program_id
      end
      get_programs = get_programs & programs_array

    end

    if ( !@values_to_search_5.empty? )
      these_values = @values_to_search_5.map{ |e| "'" + e + "'" }.join(', ')
      get_programs_query = FieldsString.select_programs_by_filter_value( "doctoral_dental_degree_offered", these_values )

      programs_array = Array.new
      get_programs_query.each do |p|
        programs_array << p.program_id
      end
      get_programs = get_programs & programs_array

    end

    @programs = Program.select_programs_sorted_alphabetically( get_programs )

  end

  def information

    @display_username = session[:display_username]
    @user_roles = session[:user_roles]

    if ( @display_username.nil? )
      redirect_to root_path
    end

    @id = params[:id]
    @program = Program.find(@id)
    @field_string = FieldsString.find_by_program_id(@id)

    @fields_to_display = FieldName.select_fields_to_display( @id )

    # Get all of the table configurations (title, number of rows and columns)
    @data_table_configs = DataTableConfig.select_tables_by_program_id( @id )

    # Get how many table configurations
    table_types_amount = @data_table_configs.count
    @table_types = Array.new( table_types_amount + 1 )
    @table_names = Array.new( table_types_amount + 1 )

    # Create array containing headers, subheaders, categories and data for each table
    @data_table_configs.each do |table_configuration|

      first_data_row = 0
      this_row = table_configuration.rows
      this_column_subheader = 1

      # +1 since arrays start in 0
      @table = Array.new( table_configuration.rows + 1 ) { Array.new( table_configuration.columns + 1) }

      data_table = DataTable.select_table_config_by_program_id( @id, table_configuration.id )
      data_table.each do |cell|

        # Get the number of the first data row
        if (first_data_row == 0)
          first_data_row = cell.cell_row
        end

        # Fills each table type with its cell values per row and column
        if ( cell.cell_value.to_s == "x" || ( cell.cell_value.to_s.include? "x ") || ( cell.cell_value.to_s.include? "x\n") || ( cell.cell_value.to_s.include? "x\r") )
          # ascii checkmark symbol
          @table[ cell.cell_row ][ cell.cell_column ] = cell.cell_value.to_s.gsub("x","\u2713")
        else
          @table[ cell.cell_row ][ cell.cell_column ] = cell.cell_value.to_s
        end

      end

      # Add categories to the table from the bottom up
      categories = Category.select_categories_by_table_config_id( table_configuration.id )
      categories.each do |category|
        if ( category.category.to_s == "x" || ( category.category.to_s.include? "x " ) || ( category.category.to_s.include? "x\n") || ( category.category.to_s.include? "x\r") )
          # ascii checkmark symbol
          @table[ this_row ][ 1 ] = category.category.to_s.gsub("x","\u2713")
        else
          @table[ this_row ][ 1 ] = category.category
        end
        this_row -= 1
      end

      # Add subheaders to the table from right to left (if the table has subheaders)
      # row 1 = header, row 2 = subheader
      # If first_data_row = 2 there are no subheaders for the table, just a header
      duplicate_subheaders = false
      if ( first_data_row == 3 )
        subheaders = SubHeader.select_subheaders_by_table_name_id( table_configuration.table_name_id )

        # -1 because it needs to exclude the categories subheader
        amount_of_subheaders = subheaders.count - 1

        if ( amount_of_subheaders > 0 )

          # If the amount of subheaders (minus the category subheader) mod 2 = 0 then
          # all the subheaders need to get duplicated as a comparison table
          if ( ( table_configuration.columns - 1 ) % 2 == 0 )
            duplicate_subheaders = true
          end

          subheaders.each do |subheader|
            @table[ 2 ][ this_column_subheader ] = subheader.subheader

            # Subheaders duplication will happen at current column number + amount_of_subheaders
            if ( duplicate_subheaders && this_column_subheader >= 2 )
              @table[ 2 ][ this_column_subheader + amount_of_subheaders ] = subheader.subheader
            end
            this_column_subheader += 1
          end

        end
      end

      headers = MainHeader.select_headers_by_table_name_id( table_configuration.table_name_id )
      amount_of_headers = headers.count

      # Standard table headers start at column 1,
      # if subheaders exist, then headers start at column 2
      if ( duplicate_subheaders )
        column_increment = amount_of_subheaders
        this_column_header = 2
      else
        column_increment = 1
        this_column_header = 1
      end

      headers.each do |header|

        # Adds a column span number between hash symbols for column >= 2
        if ( this_column_header >= 2)
          @table[ 1 ][ this_column_header ] = "#" + column_increment.to_s + "#" + header.header.to_s
        else
          @table[ 1 ][ this_column_header ] = header.header.to_s
        end
        this_column_header += column_increment

      end

      # Get table name
      table_title = TableName.find( table_configuration.table_name_id )

      @table_types[ table_configuration.table_name_id ] = @table
      @table_names[ table_configuration.table_name_id ] = table_title.display_table_name
    end

  end

end
