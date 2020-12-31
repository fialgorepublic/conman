class AddAssignedEmailToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :assigned_email, :string
  end
end
