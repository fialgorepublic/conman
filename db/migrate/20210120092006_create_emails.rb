class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :subject
      t.text :body
      t.string :message_id
      t.integer :user_id

      t.timestamps
    end
  end
end
