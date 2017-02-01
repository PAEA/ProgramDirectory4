class CreateSchools < ActiveRecord::Migration[5.0]
  def change
    create_table :schools do |t|
      t.string :state
      t.string :university
      t.string :school
      t.string :dean
      t.text   :general_information
      t.text   :mission
      t.text   :curriculum
      t.string :research_opportunities
      t.string :research_types
      t.string :degree_programs
      t.string :type_of_institution
      t.string :year_opened
      t.string :term_type
      t.string :time_to_degree
      t.string :start_month
      t.string :doctoral_degree
      t.string :targeted_predoctoral
      t.string :targeted_class_size
      t.string :campus_setting
      t.string :campus_housing

      t.timestamps
    end

  end
end
