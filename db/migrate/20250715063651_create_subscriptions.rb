class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true
      t.references :license, null: true, foreign_key: true
      t.references :payment, null: true, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :subscriptions, [ :user_id, :term_id ], unique: true
    add_index :subscriptions, :status
  end
end
