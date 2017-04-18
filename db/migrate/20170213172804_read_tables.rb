require "csv"

class ReadTables < ActiveRecord::Migration[5.0]

  def change

    # Table's metadata parameters in CSVs
    section_parameter = 'section'
    order_parameter = 'order'
    table_name_parameter = 'table_name'
    display_table_name_parameter = 'display_table_name'
    table_content_parameter = 'content'

    # Creates Table Names table in the database
    create_table :table_names do |t|
      t.string :table_name
      t.string :display_table_name

      t.timestamps
    end

    # Creates Sections table in the database
    create_table :display_sections do |t|
      t.string :section_name
      t.integer :section_order
      t.string :section_to_link
      t.string :section_type

      t.timestamps
    end

    # Creates Categories table in the database
    create_table :categories do |t|
      t.integer :data_table_config_id
      t.string :category

      t.timestamps
    end

    # Creates Main Headers table in the database
    create_table :main_headers do |t|
      t.integer :table_name_id
      t.string :header

      t.timestamps
    end

    # Creates Sub Headers table in the database
    create_table :sub_headers do |t|
      t.integer :table_name_id
      t.string :subheader

      t.timestamps
    end

    # Creates Programs table in the database
    create_table :programs do |t|
      t.string :program
      t.string :program_string

      t.timestamps
    end

    # Creates Data Tables Config table in the database
    create_table :data_table_configs do |t|
      t.integer :program_id
      t.integer :table_name_id
      t.integer :rows
      t.integer :columns

      t.timestamps
    end

    # Creates DataTables table in the database
    create_table :data_tables do |t|
      t.integer :data_table_config_id
      t.integer :header_id
      t.integer :subheader_id
      t.integer :extraheader_id
      t.integer :category_id
      t.string  :cell_value
      t.integer :program_id
      t.integer :cell_row
      t.integer :cell_column

      t.timestamps
    end

    programs = Array.new

    # Initialize how many different configurations for the tables
    current_table_config_id = 1

    Dir.glob("table_*.csv") do |csvfile|

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
        end

        metadata_line += 1
        current_metadata = array_from_csv[metadata_line][0].to_s.strip.gsub(/\r/,"").gsub(/\n/,"")
        current_metadata_value = array_from_csv[metadata_line][1].to_s.strip

      end
      table_start_line = metadata_line + 1

      current_table = TableName.create(
        table_name: table_name,
        display_table_name: display_table_name
      )

      if ( !display_table_name.blank? )
        puts "--> Table title: " + display_table_name + "(" + table_name + ")"
      else
        puts "--> Table title: (no title) (" + table_name + ")"
      end

      current_display_section = DisplaySection.create(
        section_name: table_section,
        section_order: table_order,
        section_to_link: table_name,
        section_type: 'table'
      )

      display_rows = rows + 1 # Starting from 1 (instead of 0)
      display_columns = columns - 1 # Removing program's column

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
      final_table_amount_of_rows = ( rows - dental_school_row ) * ( columns - 2 )

      # Declare array to store values in the DB
      final_table = Array.new( final_table_amount_of_rows ) { Array.new(9) }

      # Get header column above the data, adds each header to the headers array and substitute the header text with its array id
      for x in 1..columns

        # Find each header in the column within headers array
        header = main_headers.find_index( array_from_csv[table_start_line][x] )

        if ( header.nil? && !array_from_csv[table_start_line][x].nil? )
          main_headers << array_from_csv[table_start_line][x]
          array_from_csv[table_start_line][x] = main_headers.size
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
            array_from_csv[dental_school_row][x] = sub_headers.size
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
      row_per_program_counter = 0

      # Read how many rows of data for the first program in the CSV file
      # The rest of the programs will have the same amount of rows
      for y in data_start_row..rows
        if ( current_program_id == array_from_csv[ y ][ 0 ] )
          row_per_program_counter += 1
          current_program_id = array_from_csv[ y ][ 0 ]
        end
      end

      current_program_id = 0
      matrix_row = @table_header_rows + 1
      for y in data_start_row..rows
        if ( current_program_id != array_from_csv[ y ][ 0 ] )
          current_program_id = array_from_csv[ y ][ 0 ]

          # Adds table configuration to the DB table Data Tables Config
          new_table = DataTableConfig.create(
            program_id: current_program_id,
            table_name_id: current_table.id,
            rows: row_per_program_counter + @table_header_rows,
            columns: display_columns
          )
          current_table_config_id = new_table.id
        end

        # Store each category for each table for each program
        if ( !array_from_csv[ y ][ 1 ].nil? )
          new_category = Category.create(
            data_table_config_id: current_table_config_id,
            category: array_from_csv[ y ][ 1 ]
          )
          array_from_csv[ y ][ 1 ] = new_category.id
        end

        for x in 2..columns
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

        if ( matrix_row > row_per_program_counter + @table_header_rows )
          matrix_row = @table_header_rows + 1
        end

      end

      #def print_2d_array(a, cs=12)
      #  report = []
      #  report << " " * 5 + a[0].enum_for(:each_with_index).map { |e, i|
      #    "%#{cs}s" % [i+1, " "]}.join("   ")
      #  report << a.enum_for(:each_with_index).map { |ia, i|
      #    "%2i [ %s ]" % [i+1, ia.map{|e| "%#{cs}s" % e}.join(" | ") ] }
      #  puts report.join("\n")
      #end
      #if ( table_order == "75" )
      #  print_2d_array(final_table)
      #end

      # Stores main_headers array in the DB table Main Headers
      main_headers.each do |head|
        new_header = MainHeader.create(
          table_name_id: current_table.id,
          header: head
        )
      end

      # Stores sub_headers array in the DB table Sub Headers
      sub_headers.each do |subhead|
        new_header = SubHeader.create(
          table_name_id: current_table.id,
          subheader: subhead
        )
      end

      # Stores final_table bidimensional array in the DB table DataTables
      final_table.each do |row|

        # Check that the cell's row (row[6]) and column (row[7]) values are not NULL
        # so there are no blank records in the DB table
        if ( !row[6].nil? && !row[7].nil? )
          new_row = DataTable.create(
            header_id: row[0],
            subheader_id: row[1],
            extraheader_id: row[2],
            category_id: row[3],
            cell_value: row[4],
            program_id: row[5],
            cell_row: row[6],
            cell_column: row[7],
            data_table_config_id: row[8]
          )
        end
      end

    end # Dir.glob

    # Stores programs array in the DB table Programs
    #programs.each do |prog|
    #  new_program = Program.create(
    #    program: prog
    #  )
    #end

  end

end
