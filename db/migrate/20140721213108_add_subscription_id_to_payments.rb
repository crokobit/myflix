class AddSubscriptionIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :subscription_id, :string
  end
end
