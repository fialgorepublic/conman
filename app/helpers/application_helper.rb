module ApplicationHelper
  def find_mail_from_contact(mail_id)
    Contact.where(email_id: mail_id).first
  end
end
