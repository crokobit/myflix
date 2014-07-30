class AddSubscriptionDataToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :start_time, :datetime
    add_column :payments, :end_time, :datetime
    add_column :payments, :cancel_at_period_end, :boolean
  end
end
