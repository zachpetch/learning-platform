class AddUniqueUserCourseOfferingIndexToPayments < ActiveRecord::Migration[8.0]
  def change
    add_index :payments, [ :user_id, :course_offering_id ], unique: true
  end
end
