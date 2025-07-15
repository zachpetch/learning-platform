class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.references :school, null: false, foreign_key: true
      t.string :subject, null: false
      t.integer :number, null: false
      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :courses, [:school_id, :subject, :number], unique: true
    add_index :courses, [:school_id, :subject]
  end
end
