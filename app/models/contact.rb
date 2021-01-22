class Contact < ApplicationRecord
	belongs_to :user
	belongs_to :email
	validates :sender_email, presence: true
end
