class Settings < ActiveRecord::Migration[5.0]

  def up

    create_table :settings do |t|
      t.date :editing_from
      t.date :editing_to
      t.string :email_notifications

      t.timestamps
    end

    create_table :settings_roles do |t|
      t.string :role, :limit => 50
      t.string :role_type, :limit => 10
      t.string :type, :limit => 10

      t.timestamps
    end

    create_table :settings_fields do |t|
      t.references :settings_roles, index: true
      t.references :display_sections, index: true

      t.timestamps
    end

  end

  def down

    drop_table :settings
    drop_table :settings_roles
    drop_table :settings_fields

  end

end
