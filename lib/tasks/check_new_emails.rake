namespace :emails do
  task check_new_email: :environment do
  	@imap = Net::IMAP.new('imap.gmail.com', 993, usessl = true, certs = nil, verify = false)
  	@imap.login('administrator@conmanapp.net', 'rjeipagbbqlipjsy')
  	@imap.select('Inbox')
  	emails = @imap.search(["UNSEEN"])
  	if emails.any?
  		emails.each do |message_id|
  			email = @imap.fetch(message_id,'RFC822')[0].attr['RFC822']
  			mail = Mail.read_from_string email
  			body = HtmlToPlainText.plain_text(mail.html_part.body.to_s).gsub("\n", "<br />").html_safe if mail.html_part.present?
  			message_id = mail.message_id
  			sender_name = mail[:from].display_names.first
  			sender_email =  mail.from[0]
  			cc =  mail.cc
  			bcc =  mail.bcc
  			receiver_email = mail.to[0] 
  			user = User.find_by(assigned_email: receiver_email)
  			if user.present?
  				 @result = HTTParty.post("http://conman.app/conman/extract_information", {
                body: "text=#{body}",
                headers: {
                  'Content-Type' => 'application/x-www-form-urlencoded',
                  'charset' => 'utf-8'
                }
              })
  				if @result["data"].any?
            @result["data"].each do |result|
  				 	get_contact = Contact.find_by(sender_email: result["emails"][0])
  				  unless get_contact.present?
	  				 contact = user.contacts.new
	  				 contact.name = result["names"][0]
	  				 contact.designation = result["job_titles"].present? ? result["job_titles"] : nil
	  				 contact.blink_carbon_copy = bcc
	  				 contact.facebook_url = result["social_link"]["facebook"][0]
	  				 contact.twitter_url = result["social_link"]["twitter"][0] 
	  				 contact.sender_email = result["emails"].first
	  				 contact.carbon_copy = cc
	  				 contact.email_id = message_id
	  				 contact.linkedin_url = result["social_link"]["linkedin"][0]
	  				 contact.website = result["websites"][0]
	  				 contact.save
              end
            end
  				 	end
  			end
  		end
  	end
  end
end