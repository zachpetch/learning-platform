class AddShortNameToSchools < ActiveRecord::Migration[8.0]
  def change
    add_column :schools, :short_name, :string

    School.reset_column_information

    short_names = {
      "University of British Columbia" => "UBC",
      "University of Victoria" => "UVic",
      "Simon Fraser University" => "SFU",
      "Okanagan College" => "OC"
    }

    School.find_each do |school|
      short = short_names[school.name] || school.name.split.map { |w| w[0] }.join.upcase
      school.update_columns(short_name: short)
    end

    change_column_null :schools, :short_name, false
  end

  def down
    remove_column :schools, :short_name
  end
end
