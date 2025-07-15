class CreateCourseOfferings < ActiveRecord::Migration[8.0]
  def change
    create_table :course_offerings do |t|
      t.references :course, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true

      t.timestamps
    end

    add_index :course_offerings, [ :course_id, :term_id ], unique: true
  end
end
