class CreateTerms < ActiveRecord::Migration[8.0]
  def change
    create_table :terms do |t|
      t.references :school, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :year, null: false
      t.integer :sequence_num, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end

    add_index :terms, [ :school_id, :year, :sequence_num ], unique: true
    add_index :terms, [ :school_id, :name ], unique: true
  end
end
