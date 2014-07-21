class AddSubscriptionDataToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :start_time, :time
    add_column :payments, :end_time, :time
    add_column :payments, :cancel_at_period_end, :boolean
  end
end
