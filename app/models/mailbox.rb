class Mailbox < ApplicationRecord
	belongs_to :user
	validates :email, :uniqueness => { :case_sensitive => false }
end
