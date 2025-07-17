class AddTermCountToLicenses < ActiveRecord::Migration[8.0]
  def change
    change_table :licenses do |t|
      t.integer "term_count", default: 1, null: false
    end
  end
end
