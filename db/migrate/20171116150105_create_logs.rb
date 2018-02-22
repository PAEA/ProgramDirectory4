class CreateLogs < ActiveRecord::Migration[5.0]

  def up

    create_table :logs do |t|
      t.integer :program_id
      t.integer :field_id
      t.string :field_type
      t.text :old_value
      t.text :new_value
      t.string :display_username
      t.string :action
      t.integer :action_by

      t.timestamps
    end
    add_index :logs, [:program_id, :field_id, :created_at]

  end

  def down

    drop_table :logs

  end

end
