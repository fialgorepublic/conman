class Contact < ApplicationRecord
	belongs_to :user
	validates :sender_email, presence: true
end
