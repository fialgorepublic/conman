class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :sender_email
      t.string :receiver_email
      t.string :designation
      t.string :carbon_copy
      t.string :blink_carbon_copy
      t.string :facebook_url
      t.string :twitter_url
      t.string :linkedin_url
      t.string :email_id
      t.string :website

      t.timestamps
    end
  end
end
