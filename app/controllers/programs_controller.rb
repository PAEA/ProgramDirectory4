class ProgramsController < ApplicationController

  def index
    @programs = Program.all
  end

  def information

    @id = params[:id]
    @program = Program.find(@id)
    @field_string = FieldsString.find_by_program_id(@id)
    @fields_to_display = FieldName.find_by_sql("
    SELECT *
      FROM
      (SELECT display_sections.section_name, display_sections.section_order,
        field_names.id as id, field_names.field_name,
        field_names.display_field_name as display_name,
        fields_strings.field_value, 'field' as content_type
        FROM field_names, fields_strings, display_sections
        WHERE display_sections.section_to_link = field_names.field_name
          AND fields_strings.field_id = field_names.id
          AND fields_strings.program_id = " + @id + "
      UNION
      SELECT display_sections.section_name, display_sections.section_order,
        field_names.id as id, field_names.field_name,
        field_names.display_field_name as display_name,
        fields_texts.field_value, 'field' as content_type
        FROM field_names, fields_texts, display_sections
        WHERE display_sections.section_to_link = field_names.field_name
          AND fields_texts.field_id = field_names.id
          AND fields_texts.program_id = " + @id + "
      UNION
      SELECT display_sections.section_name, display_sections.section_order,
        field_names.id as id, field_names.field_name,
        field_names.display_field_name as display_name,
        fields_decimals.field_value, 'field' as content_type
        FROM field_names, fields_decimals, display_sections
        WHERE display_sections.section_to_link = field_names.field_name
          AND fields_decimals.field_id = field_names.id
          AND fields_decimals.program_id = " + @id + "
      UNION
      SELECT display_sections.section_name, display_sections.section_order,
        field_names.id as id, field_names.field_name,
        field_names.display_field_name as display_name,
        fields_integers.field_value, 'field' as content_type
        FROM field_names, fields_integers, display_sections
        WHERE display_sections.section_to_link = field_names.field_name
          AND fields_integers.field_id = field_names.id
          AND fields_integers.program_id = " + @id + "
      UNION
      SELECT display_sections.section_name, display_sections.section_order,
        table_names.id as id, table_names.table_name,
        table_names.display_table_name as display_name,
        0, 'table' as content_type
        FROM display_sections, table_names, data_table_configs
        WHERE display_sections.section_to_link = table_names.table_name
          AND data_table_configs.table_name_id = table_names.id
          AND data_table_configs.program_id = " + @id + ") as tables_union
      ORDER BY tables_union.section_order
    ")

    # Get all of the table configurations (title, number of rows and columns)
    @data_table_configs = DataTableConfig.where( program_id: @id )

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

      data_table = DataTable.where( :program_id => @id ).where( :data_table_config_id => table_configuration.id )
      data_table.each do |cell|

        # Get the number of the first data row
        if (first_data_row == 0)
          first_data_row = cell.cell_row
        end

        # Fills each table type with its cell values per row and column
        if ( cell.cell_value.to_s == "x" )
          # ascii checkmark symbol
          @table[ cell.cell_row ][ cell.cell_column ] = "\u2713"
        else
          @table[ cell.cell_row ][ cell.cell_column ] = cell.cell_value.to_s
        end

      end

      # Add categories to the table from the bottom up
      categories = Category.where( :data_table_config_id => table_configuration.id ).order(id: :desc)
      categories.each do |category|
        @table[ this_row ][ 1 ] = category.category
        this_row -= 1
      end

      # Add subheaders to the table from right to left (if the table has subheaders)
      # row 1 = header, row 2 = subheader
      # If first_data_row = 2 there are no subheaders for the table, just a header
      duplicate_subheaders = false
      if ( first_data_row == 3 )
        subheaders = SubHeader.where( :table_name_id => table_configuration.table_name_id ).order(id: :asc)

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

      headers = MainHeader.where( :table_name_id => table_configuration.table_name_id ).order(id: :asc)
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
