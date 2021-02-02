class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 	validates :username, presence: true, uniqueness: true

  has_many :mailboxes, dependent: :destroy
  has_many :contacts, dependent: :destroy, inverse_of: :user
  has_many :emails, dependent: :destroy
  after_create :assign_email

  def assign_email
    user_email = "#{SecureRandom.alphanumeric(9)}@accumail.co.za"
  	update_attributes(assigned_email: user_email.downcase)
  end
end
