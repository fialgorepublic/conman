module ApplicationHelper
  def find_mail_from_contact(mail_id)
    Contact.where(email_id: mail_id).first
  end

  def email_body(email)
  	HtmlToPlainText.plain_text(email.body.to_s).gsub("\n", "").html_safe
  end
end
