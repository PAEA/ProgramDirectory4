require "csv"

class GeneralInformation < ActiveRecord::Migration[5.0]
  def change

    # Creates About table in the database
    create_table :abouts do |t|
      t.string :school
      t.string :state
      t.string :dean
      t.text   :general_information
      t.text   :mission

      t.timestamps
    end

    # Creates Fast Facts table in the database
    create_table :fast_facts do |t|
      t.string :school
      t.string :type_of_institution
      t.integer :year_opened
      t.string :term_type
      t.integer :time_to_degree
      t.string :start_month
      t.string :doctoral_degree
      t.integer :targeted_predoctoral
      t.integer :targeted_class_size
      t.string :campus_setting
      t.string :campus_housing

      t.timestamps
    end

    # Creates Curriculum table in the database
    create_table :curriculums do |t|
      t.string :school
      t.text   :curriculum
      t.string :research_opportunities
      t.string :research_types
      t.string :degree_programs

      t.timestamps
    end

  end
end
