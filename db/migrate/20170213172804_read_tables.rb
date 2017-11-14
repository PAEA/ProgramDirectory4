require "csv"

class ReadTables < ActiveRecord::Migration[5.0]

  def truefalse( yes_no_variable )
    if ( yes_no_variable == 'yes' )
      return true
    else
      return false
    end
  end

  def up

    # Table's metadata parameters in CSVs
    section_parameter = 'section'
    order_parameter = 'order'
    table_name_parameter = 'table_name'
    display_table_name_parameter = 'display_table_name'
    table_content_parameter = 'content'
    table_has_categories_parameter = 'table_has_categories'
    filter_by_parameter = 'filter_by'
    filter_display_order_parameter = 'filter_display_order'

    # Creates Programs table in the database
    create_table :programs do |t|
      t.string :program, :limit => 100
      t.string :program_string, :limit => 90

      t.timestamps
    end

    # Creates a table for preselected filters either in fields or table categories
    create_table :custom_filters do |t|
      t.string :custom_filter, :limit => 70
      t.string :source, :limit => 5
      t.integer :display_order, :limit => 2, :default => 99

      t.timestamps
    end

    # Creates Table Names table in the database
    create_table :table_names do |t|
      t.string :table_name, :limit => 70
      t.string :display_table_name, :limit => 100

      t.timestamps
    end

    # Creates Sections table in the database
    create_table :display_sections do |t|
      t.string :section_name, :limit => 60
      t.integer :section_order, :limit => 2
      t.string :section_to_link, :limit => 80
      t.string :section_type, :limit => 5

      t.timestamps
    end

    # Creates Data Tables Config table in the database
    create_table :data_table_configs do |t|
      t.references :program, index: true
      t.references :table_name, index: true
      t.integer :rows, :limit => 2
      t.integer :columns, :limit => 2
      t.boolean :has_categories

      t.timestamps
    end

    # Creates Categories table in the database
    create_table :categories do |t|
      t.references :data_table_config, index: true
      t.string :category, :limit => 100

      t.timestamps
    end

    # Creates Main Headers table in the database
    create_table :main_headers do |t|
      t.references :table_name, index: true
      t.string :header, :limit => 95

      t.timestamps
    end

    # Creates Sub Headers table in the database
    create_table :sub_headers do |t|
      t.references :table_name, index: true
      t.string :subheader, :limit => 50

      t.timestamps
    end

    # Creates DataTables table in the database
    create_table :data_tables do |t|
      t.references :data_table_config, index: true
      t.references :main_header, index: true
      t.references :sub_header, index: true
      t.references :category, index: true
      t.text  :cell_value
      t.text  :cell_value_temp
      t.references :program, index: true
      t.integer :cell_row, :limit => 2
      t.integer :cell_column, :limit => 2

      t.timestamps
    end

    programs = Array.new

    # Initialize how many different configurations for the tables
    current_table_config_id = 1

    Dir.glob("csv/table_*.csv") do |csvfile|

      puts "\nFILE: " + csvfile

      categories = Array.new
      main_headers = Array.new
      sub_headers = Array.new

      array_from_csv = CSV.read( csvfile ).reject { |row| row.all?(&:nil?) }

      # Get how many rows and columns for this table
      rows = array_from_csv.size - 1
      columns = array_from_csv[0].size

      # Get first cell in the CSV array_from_csv
      # The 'content' value marks the end for the metadata rows and the
      # beginning for the table data starting on next row
      metadata_line = 0
      current_metadata = array_from_csv[metadata_line][0].to_s.strip.gsub(/\r/,"").gsub(/\n/,"").gsub!(/\P{ASCII}/, '')
      current_metadata_value = array_from_csv[metadata_line][1].to_s.strip

      while ( current_metadata != table_content_parameter && metadata_line <= rows ) do

        if ( current_metadata == section_parameter )
          table_section = current_metadata_value
        elsif ( current_metadata == order_parameter )
          table_order = current_metadata_value
        elsif ( current_metadata == table_name_parameter )
          table_name = current_metadata_value
        elsif ( current_metadata == display_table_name_parameter )
          display_table_name = current_metadata_value
        elsif ( current_metadata == filter_by_parameter )
          filter_by = truefalse(current_metadata_value)
        elsif ( current_metadata == filter_display_order_parameter )
          filter_display_order = current_metadata_value
        elsif ( current_metadata == table_has_categories_parameter )
          table_has_categories = truefalse(current_metadata_value)
        end

        metadata_line += 1
        current_metadata = array_from_csv[metadata_line][0].to_s.strip.gsub(/\r/,"").gsub(/\n/,"")
        current_metadata_value = array_from_csv[metadata_line][1].to_s.strip

      end

      # Get first row where the table data starts in the csv file
      table_start_line = metadata_line + 1

      # Store table name
      current_table = TableName.create(
        table_name: table_name,
        display_table_name: display_table_name
      )

      if ( !display_table_name.blank? )
        puts "--> Table title: " + display_table_name + " (" + table_name + ")"
      else
        puts "--> Table title: (no title) (" + table_name + ")"
      end

      # Store the information section and its order
      current_display_section = DisplaySection.create(
        section_name: table_section,
        section_order: table_order,
        section_to_link: table_name,
        section_type: 'table'
      )

      display_rows = rows + 1 # Starting from 1 (instead of 0)
      display_columns = columns - 1 # Removing program's column

      # If the table categories are labeled as filters...
      if ( filter_by )
        new_filter = CustomFilter.create(
          custom_filter: table_name,
          source: 'table',
          display_order: filter_display_order
        )
      end

      # Get row number for cell 'Dental School' starting from the next line after 'content'
      # in the CSV file
      @table_header_rows = 1
      dental_school_row = metadata_line + 1
      while ( array_from_csv[ dental_school_row ][0].to_s.strip != "Dental School" ) do
        dental_school_row += 1
        @table_header_rows += 1
      end

      # Check how many rows with data
      for y in dental_school_row..rows
        if ( array_from_csv[ y ][0].blank? )
          break
        else
          # Remove blanks, line feeds and carriage returns
          array_from_csv[ y ][0] = array_from_csv[ y ][0].to_s.strip.gsub(/\r/," ").gsub(/\n/," ").gsub("  ", " ")
          array_from_csv[ y ][1] = array_from_csv[ y ][1].to_s.strip.gsub(/\r/," ").gsub(/\n/," ").gsub("  ", " ")
        end
      end
      rows = y

      # Get first row number with data values
      data_start_row = dental_school_row + 1

      final_table_amount_of_rows = ( rows - dental_school_row ) * ( columns - (table_has_categories ? 2 : 1) )

      # Declare array to store values in the DB
      final_table = Array.new( final_table_amount_of_rows ) { Array.new(9) }

      # Get header column above the data, adds each header to the headers array and substitute the header text with its array id
      for x in 1..columns

        # Find each header in the column within headers array
        header = main_headers.find_index( array_from_csv[table_start_line][x] )

        if ( header.nil? && !array_from_csv[table_start_line][x].nil? )
          main_headers << array_from_csv[table_start_line][x]
          new_header = MainHeader.create(
            table_name_id: current_table.id,
            header: array_from_csv[table_start_line][x]
          )
          array_from_csv[table_start_line][x] = new_header.id
        else
          # Add 1 since array index starts with 0
          if ( !header.nil? )
            array_from_csv[table_start_line][x] = header + 1
          end
        end

        if ( dental_school_row  > table_start_line )
          header = sub_headers.find_index( array_from_csv[dental_school_row][x] )

          if ( header.nil? && !array_from_csv[dental_school_row][x].nil? )
            sub_headers << array_from_csv[dental_school_row][x]
            new_subheader = SubHeader.create(
              table_name_id: current_table.id,
              subheader: array_from_csv[dental_school_row][x]
            )
            array_from_csv[dental_school_row][x] = new_subheader.id
          else
            # Add 1 since array index starts with 0
            if ( !header.nil? )
              array_from_csv[dental_school_row][x] = header + 1
            end
          end
        end

      end

      # Get category and program rows to the left of the data row,
      # adds category to the categories array,
      # adds program to the programs array and
      # substitute the category text and program text with its array id
      for y in data_start_row..rows

        # Filter out all characters except letters from the program name.
        # This is done to avoid small differences in the program names
        # caused by a comma, a dash or any other special character
        program_string = array_from_csv[y][0].gsub(/[^a-zA-Z]/, "").downcase

        # Find row program within programs array
        program = programs.find_index( program_string )

        # Adds new program to programs array if it doesn't exist
        if ( program.nil? && !program_string.nil? )

          new_program = Program.create(
            program: array_from_csv[y][0],
            program_string: program_string
          )

          programs << program_string
          array_from_csv[y][0] = programs.size

        else
          if ( !program.nil? )
            # Add 1 since array index starts with 0
            array_from_csv[y][0] = program + 1
          else
            array_from_csv[y][0] = nil
          end
        end

      end

      # Prepare normalized data table
      rows_counter = 0
      current_program_id = array_from_csv[ data_start_row ][ 0 ]
      #row_per_program_counter = 0

      # Read how many rows of data for the first program in the CSV file
      # The rest of the programs will have the same amount of rows
      #for y in data_start_row..rows
      #  if ( current_program_id == array_from_csv[ y ][ 0 ] )
      #    row_per_program_counter += 1
          #current_program_id = array_from_csv[ y ][ 0 ]
      #  end
      #end

      current_program_id = 0
      matrix_row = @table_header_rows + 1
      for y in data_start_row..rows

        row_per_program_counter = 0
        if ( current_program_id != array_from_csv[ y ][ 0 ] )
          current_program_id = array_from_csv[ y ][ 0 ]

          for r in y..rows
            if ( current_program_id == array_from_csv[ r ][ 0 ] )
              row_per_program_counter += 1
            else
              break
            end
          end

          # Adds table configuration to the DB table Data Tables Config
          new_table = DataTableConfig.create(
            program_id: current_program_id,
            table_name_id: current_table.id,
            rows: row_per_program_counter + @table_header_rows,
            columns: display_columns,
            has_categories: table_has_categories
          )
          current_table_config_id = new_table.id

          matrix_row = @table_header_rows + 1
        end

        # Store each category for each table for each program

        if ( table_has_categories )
          if ( !array_from_csv[ y ][ 1 ].blank? )
            new_category = Category.create(
              data_table_config_id: current_table_config_id,
              category: array_from_csv[ y ][ 1 ]
            )
            array_from_csv[ y ][ 1 ] = new_category.id
          end
          starting_column = 2
        else
          starting_column = 1
        end

        for x in starting_column..columns
          if ( !array_from_csv[ y ][ x ].nil? )

            # Adds headers
            column_counter = 0
            for header_row in table_start_line..dental_school_row
              final_table[ rows_counter ][ column_counter ] = array_from_csv[ header_row ][ x ]

              column_counter += 1
            end

            # Adds category
            final_table[ rows_counter ][ 3 ] = array_from_csv[ y ][ 1 ]
            # Adds value
            final_table[ rows_counter ][ 4 ] = array_from_csv[ y ][ x ]
            # Adds program
            final_table[ rows_counter ][ 5 ] = array_from_csv[ y ][ 0 ]
            # Adds row and column position for the cell value
            # (this will get handy for rebuilding and displaying the table)
            final_table[ rows_counter ][ 6 ] = matrix_row # row
            final_table[ rows_counter ][ 7 ] = x # column
            final_table[ rows_counter ][ 8 ] = current_table_config_id

            rows_counter += 1
          end
        end
        matrix_row += 1

      end

      # Stores final_table bidimensional array in the DB table DataTables
      final_table.each do |row|

        # Check that the cell's row (row[6]) and column (row[7]) values are not NULL
        # so there are no blank records in the DB table
        if ( !row[6].nil? && !row[7].nil? )
          new_row = DataTable.create(
            main_header_id: row[0],
            sub_header_id: row[1],
            category_id: row[3],
            cell_value: row[4],
            program_id: row[5],
            cell_row: row[6],
            cell_column: row[7],
            data_table_config_id: row[8]
          )
        end

      end

    end

  end

  def down

    drop_table :table_names

    drop_table :display_sections

    drop_table :categories

    drop_table :main_headers

    drop_table :sub_headers

    drop_table :programs

    drop_table :data_table_configs

    drop_table :data_tables

    drop_table :custom_filters

  end

end
