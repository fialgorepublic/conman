namespace :emails do
  task check_new_email: :environment do
    @imap = Net::IMAP.new('mail.accumail.co.za', 993, usessl = true, certs = nil, verify = false)
    @imap.login('kjuwcaaa3@accumail.co.za', 'k=S,fwHNMxF!')
    @imap.select('Inbox')
    emails = @imap.search(["UNSEEN"])
    if emails.any?
      emails.each do |message_id|
        email = @imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
        mail = Mail.read_from_string email
        mail_body = mail.html_part.body if mail.html_part.present?
        subject = mail.subject
        body = HtmlToPlainText.plain_text(mail.html_part.body.to_s).gsub("\n", "<br />").html_safe if mail.html_part.present?
        mail_id = mail.message_id
        sender_name = mail[:from].display_names.first
        sender_email = mail.from[0]
        cc = mail.cc
        bcc = mail.bcc
        receiver_email = mail.to[0]
        user = User.find_by(assigned_email: receiver_email)
        if user.present?
          mails = user.emails.where(message_id: mail.message_id).first
          if mails.blank?
            @mail = user.emails.create(subject: subject, body: mail_body, message_id: mail.message_id)
            @result = HTTParty.post("http://conman.app/conman/extract_information", {
              body: "text=#{body}",
              headers: {
                'Content-Type' => 'application/x-www-form-urlencoded',
                'charset' => 'utf-8'
              }
            })
            if @result["data"].any?
              @result["data"].each_with_index do |result, index|
                contact = @mail.contacts.new
                contact.user_id = user.id
                contact.name = result["names"][0]
                contact.designation = result["job_titles"].present? ? result["job_titles"] : nil
                contact.blink_carbon_copy = bcc
                contact.facebook_url = result["social_link"]["facebook"][0]
                contact.twitter_url = result["social_link"]["twitter"][0]
                contact.sender_email = result["emails"].first
                contact.receiver_email = @result["data"][index]["emails"].first
                contact.carbon_copy = cc
                contact.message_id = mail_id
                contact.linkedin_url = result["social_link"]["linkedin"][0]
                contact.website = result["websites"][0]
                contact.save
              end
            end
          end
        end
        @imap.store(message_id, "+FLAGS", [:Deleted])
        @imap.expunge
      end
    end
  end
end