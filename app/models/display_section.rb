class DisplaySection < ApplicationRecord

  def self.select_display_section_id( section )
    where(:section_to_link => section ).take
  end

end
