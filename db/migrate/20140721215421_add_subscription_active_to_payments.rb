class AddSubscriptionActiveToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :subscription_active, :boolean
  end
end
