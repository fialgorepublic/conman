class EmailsController < ApplicationController
  before_action :set_email, only: [:show, :destroy]
  def index
  	@emails = current_user.emails
  end

  def show
  end

  def destroy
  	@email.destroy
  end


  def set_email
  	@email = Email.find(params[:id])
  end
end
