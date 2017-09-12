class Setting < ApplicationRecord

  def self.select_roles
    all.order(:role)
  end

  def self.select_edit_fields_by_role( role_id )
    find_by_sql("
      SELECT display_sections.id, display_sections.section_name,
        display_sections.section_order, display_sections.section_type,
        display_sections.section_to_link, t1.display_sections_id, t1.settings_roles_id
      FROM display_sections
      LEFT JOIN (SELECT settings_fields.* FROM settings_fields WHERE settings_fields.settings_roles_id = " + role_id + ") AS t1
        ON display_sections.id = t1.display_sections_id
      ORDER BY display_sections.section_order")
  end

  def self.update_settings( id, from, to, emails )

    Setting.where( :id => id ).update(editing_from: from, editing_to: to, email_notifications: emails)

  end

end
