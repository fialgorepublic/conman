class CreateMailboxes < ActiveRecord::Migration[5.2]
  def change
    create_table :mailboxes do |t|
      t.string :email
      t.string :password
      t.string :client
      t.string :username
      t.integer :user_id

      t.timestamps
    end
  end
end
