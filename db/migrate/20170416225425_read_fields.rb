require "csv"

class ReadFields < ActiveRecord::Migration[5.0]

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
    field_name_parameter = 'field'
    field_type_parameter = 'type'
    field_content_parameter = 'content'
    filter_by_parameter = 'filter_by'
    filter_display_order_parameter = 'filter_display_order'

    # Creates Field Names table in the database
    create_table :field_names do |t|
      t.string :field_name, :limit => 70
      t.string :display_field_name

      t.timestamps
    end

    # Creates Field Integers table in the database
    create_table :fields_integers do |t|
      t.integer :program_id
      t.integer :field_id
      t.integer :field_value

      t.timestamps
    end

    # Creates Field Strings table in the database
    create_table :fields_strings do |t|
      t.integer :program_id
      t.integer :field_id
      t.string :field_value

      t.timestamps
    end

    # Creates Field Texts table in the database
    create_table :fields_texts do |t|
      t.integer :program_id
      t.integer :field_id
      t.text :field_value

      t.timestamps
    end

    # Creates Field Decimals table in the database
    create_table :fields_decimals do |t|
      t.integer :program_id
      t.integer :field_id
      t.decimal :field_value

      t.timestamps
    end

    Dir.glob("csv/fields_*.csv") do |csvfile|

      array_from_csv = CSV.read( csvfile ).reject { |row| row.all?(&:nil?) }

      # Get how many rows and columns for this table
      rows = array_from_csv.size - 1
      columns = array_from_csv[0].size - 1

      for field_columns in 1..columns

        break if array_from_csv[0][field_columns].nil?

        # Get first cell in the CSV array_from_csv
        # The 'content' value marks the end for the metadata rows and the
        # beginning for the fields data starting on next row
        metadata_line = 0
        current_metadata = array_from_csv[metadata_line][0].to_s.strip.gsub(/\r/,"").gsub(/\n/,"").gsub!(/\P{ASCII}/, '')
        current_metadata_value = array_from_csv[metadata_line][field_columns].to_s.strip

        while ( current_metadata != field_content_parameter && metadata_line <= rows ) do

          if ( current_metadata == section_parameter )
            field_section = current_metadata_value
          elsif ( current_metadata == order_parameter )
            field_order = current_metadata_value
          elsif ( current_metadata == field_name_parameter )
            field_name = current_metadata_value
          elsif ( current_metadata == field_type_parameter )
            field_type = current_metadata_value
          elsif ( current_metadata == filter_by_parameter )
            filter_by = truefalse(current_metadata_value)
          elsif ( current_metadata == filter_display_order_parameter )
            filter_display_order = current_metadata_value
          end

          metadata_line += 1
          current_metadata = array_from_csv[metadata_line][0].to_s.strip.gsub(/\r/,"").gsub(/\n/,"")
          current_metadata_value = array_from_csv[metadata_line][field_columns].to_s.strip

        end
        field_start_line = metadata_line + 1

        for field_rows in field_start_line..rows

          if ( !array_from_csv[field_rows][0].to_s.strip.nil? )

            # Get the field display name, add to Field Names table and Display Sections table
            if ( field_rows == field_start_line )

              display_field_name = array_from_csv[field_rows][field_columns].to_s.strip

              current_field_name = FieldName.create(
                field_name: field_name,
                display_field_name: display_field_name
              )

              current_display_section = DisplaySection.create(
                section_name: field_section,
                section_order: field_order,
                section_to_link: field_name,
                section_type: 'field'
              )

              # If the field is labeled as a filter...
              if ( filter_by )
                new_filter = CustomFilter.create(
                  custom_filter: field_name,
                  source: 'field',
                  display_order: filter_display_order
                )
              end

              puts "--> Field name: " + display_field_name + "(" + field_name + ")"

            else

              current_program_name = array_from_csv[field_rows][0].to_s.strip.gsub(/\r/,"").gsub(/\n/,"").gsub(/[^a-zA-Z]/, "").downcase

              current_program = Program.find_by_program_string(current_program_name)
              if ( current_program.nil? )
                current_program_id = 0
              else
                current_program_id = current_program.id
              end

              if ( field_type == 'text' )

                current_field_value = FieldsText.create(
                  program_id: current_program_id,
                  field_id: current_field_name.id,
                  field_value: array_from_csv[field_rows][field_columns]
                )

              elsif ( field_type == 'string' )

                current_field_value = FieldsString.create(
                  program_id: current_program_id,
                  field_id: current_field_name.id,
                  field_value: array_from_csv[field_rows][field_columns]
                )

              elsif ( field_type == 'integer' )

                current_field_value = FieldsInteger.create(
                  program_id: current_program_id,
                  field_id: current_field_name.id,
                  field_value: array_from_csv[field_rows][field_columns]
                )

              elsif ( field_type == 'decimal' )

                current_field_value = FieldsDecimal.create(
                  program_id: current_program_id,
                  field_id: current_field_name.id,
                  field_value: array_from_csv[field_rows][field_columns]
                )

              end

            end

          end

        end

      end

    end

  end

  def down

    drop_table :field_names

    drop_table :fields_integers

    drop_table :fields_strings

    drop_table :fields_texts

    drop_table :fields_decimals

  end

end
