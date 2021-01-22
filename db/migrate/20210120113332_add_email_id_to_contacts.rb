class AddEmailIdToContacts < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :email_id, :integer
  end
end
