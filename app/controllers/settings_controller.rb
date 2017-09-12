class SettingsController < ApplicationController

  def index

    @display_username = session[:display_username]
    
    settings = Setting.first

    @settings_id = settings.id
    @editing_from = settings.editing_from
    @editing_to = settings.editing_to
    @email_notifications = settings.email_notifications
    @fields_per_role = Setting.select_edit_fields_by_role( "1" )

    @roles = SettingsRole.all

  end

  def save_settings

    settings = Setting.first

    settings_id = settings.id
    editing_from = params['sf_edit_from']
    editing_to = params['sf_edit_to']
    emails = params['sf_emails']

    # Saves dates and email addresses for notifications
    Setting.update_settings( settings_id, editing_from, editing_to, emails)

    # Deletes all field settings for selected role
    SettingsField.destroy_previous_settings( params['sf_roles'] )

    # Saves new field settings
    params.each do |item|
      section_type = item[0..5]

      # Only saves settings for fields allowed for editing
      if ( ( section_type == "field_" || section_type == "table_" ) && params[item] == "1" )
        section_to_link = item[6..item.length]
        display_sections = DisplaySection.select_display_section_id( section_to_link )
        SettingsField.add_field( 1, display_sections.id )
      end
    end

    redirect_to :back

  end

end
