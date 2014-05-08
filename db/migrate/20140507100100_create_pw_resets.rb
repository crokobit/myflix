class CreatePwResets < ActiveRecord::Migration
  def change
    create_table :pw_resets do |t|
      t.integer :user_id
      t.string :token
    end
  end
end
