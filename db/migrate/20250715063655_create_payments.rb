class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subscription, null: true, foreign_key: true
      t.references :course_offering, null: true, foreign_key: true
      t.integer :amount, null: false
      t.string :provider, null: false
      t.string :provider_transaction_id, null: false
      t.datetime :completed_at
      t.datetime :refunded_at

      t.timestamps
    end

    add_index :payments, :provider_transaction_id, unique: true
    add_index :payments, :completed_at
  end
end
