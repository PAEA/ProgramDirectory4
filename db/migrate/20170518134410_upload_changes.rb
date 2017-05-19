require "csv"

class UploadChanges < ActiveRecord::Migration[5.0]

  def change

    # Table's metadata parameters in CSVs
    section_parameter = 'section'
    order_parameter = 'order'
    field_old_name_parameter = 'old field name'
    field_new_name_parameter = 'new field name'
    field_type_parameter = 'type'
    field_content_parameter = 'content'

    Dir.glob("csv_updates/fields_*.csv") do |csvfile|

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
            field_section = current_metadata_value.to_s.strip
          elsif ( current_metadata == order_parameter )
            field_order = current_metadata_value
          elsif ( current_metadata == field_old_name_parameter )
            field_old_name = current_metadata_value.to_s.strip
          elsif ( current_metadata == field_new_name_parameter )
            field_new_name = current_metadata_value.to_s.strip
          elsif ( current_metadata == field_type_parameter )
            field_type = current_metadata_value
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

              if ( !field_old_name.blank? )
                field_name = field_old_name
                get_field_to_remove = FieldName.where(:field_name => field_old_name)
                remove_records = FieldName.delete_all "field_name = '" + field_old_name + "'"
                remove_records = DisplaySection.delete_all "section_to_link = '" + field_old_name + "'"
              else
                field_name = field_new_name
                get_field_to_remove = FieldName.where(:field_name => field_new_name)
              end
              if ( !get_field_to_remove.id.to_s.nil? )
                remove_records = FieldsText.delete_all "field_id = " + get_field_to_remove.id.to_s
                remove_records = FieldsString.delete_all "field_id = " + get_field_to_remove.id.to_s
                remove_records = FieldsInteger.delete_all "field_id = " + get_field_to_remove.id.to_s
                remove_records = FieldsDecimal.delete_all "field_id = " + get_field_to_remove.id.to_s
              end
              
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

end
