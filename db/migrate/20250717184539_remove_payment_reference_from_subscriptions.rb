class RemovePaymentReferenceFromSubscriptions < ActiveRecord::Migration[8.0]
  def change
    remove_column :subscriptions, :payment_id
  end
end
