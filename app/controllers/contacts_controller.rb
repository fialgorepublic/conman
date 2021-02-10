class ContactsController < ApplicationController
  before_action :set_cotact, only: [:edit, :update]

  def index
    if params[:email_id].present?
      @email = Email.find(params[:email_id])
      @q = @email.contacts.ransack(params[:q])
      @contacts = @q.result.paginate(page: params[:page], per_page: 20)
    else
      @q = current_user.contacts.ransack(params[:q])
      @contacts = @q.result.paginate(page: params[:page], per_page: 20)
    end
  end

  def edit
  end

  def new
    @result = HTTParty.post("http://ec2-108-128-52-36.eu-west-1.compute.amazonaws.com/conman/extract_information", {
                body: "text=#{params["body"]}",
                headers: {
                  'Content-Type' => 'application/x-www-form-urlencoded',
                  'charset' => 'utf-8'
                }
              })
    @contact = Contact.new
  end

  def create
    @contact = Contact.create(contact_params)
    redirect_to contacts_path
  end

  def update
    @contact.update_attributes(contact_params)
    redirect_to contacts_path,  flash: {success: "Contact Updated Successfully"}
  end

  def extract_multiple_mails
    debugger
    @result = HTTParty.post("http://ec2-108-128-52-36.eu-west-1.compute.amazonaws.com/conman/extract_information", {
            body: "text=#{params["body"]}",
            headers: {
              'Content-Type' => 'application/x-www-form-urlencoded',
              'charset' => 'utf-8'
            }
          })
    debugger
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :sender_email, :receiver_email, :designation, :email_id, :carbon_copy, :blink_carbon_copy, :facebook_url, :twitter_url, :linkedin_url, :website)
  end

  def set_cotact
    @contact = Contact.find(params[:id])
  end
  
end
