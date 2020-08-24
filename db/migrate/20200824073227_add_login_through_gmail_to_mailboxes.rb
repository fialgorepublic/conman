class AddLoginThroughGmailToMailboxes < ActiveRecord::Migration[5.2]
  def change
    add_column :mailboxes, :login_through_gmail, :boolean, default: false
  end
end
