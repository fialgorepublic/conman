class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :destroy]
  def index
  	@emails = current_user.emails.order(id: :desc)
  end

  def show
  end

  def destroy
  	@email.destroy
  	redirect_to emails_path
  end


  def set_email
  	@email = Email.find(params[:id])
  end
end
