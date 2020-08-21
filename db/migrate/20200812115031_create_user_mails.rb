class CreateUserMails < ActiveRecord::Migration[5.2]
  def change
    create_table :user_mails do |t|
      t.string :sender_name
      t.string :subject
      t.string :sender_email
      t.text :body
      t.integer :user_id
      t.datetime :email_date

      t.timestamps
    end
  end
end
