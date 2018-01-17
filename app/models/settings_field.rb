class SettingsField < ApplicationRecord

  def self.add_field( roles_id, display_section_id )
    new_record = SettingsField.create(
      settings_roles_id: roles_id,
      display_sections_id: display_section_id )
  end

  def self.destroy_previous_settings ( roles_id )
    destroy = SettingsField.where( :settings_roles_id => roles_id ).destroy_all
  end

  def self.get_editing_fields( user_role_id )
    where( :settings_roles_id => user_role_id )
  end

end
