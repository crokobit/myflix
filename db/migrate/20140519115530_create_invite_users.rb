class CreateInviteUsers < ActiveRecord::Migration
  def change
    create_table :invite_users do |t|
      t.integer :invitor_id
      t.string :recipient_email
      t.string :token
      t.string :recipient_name
      t.string :recipient_message

      t.timestamps
    end
  end
end
