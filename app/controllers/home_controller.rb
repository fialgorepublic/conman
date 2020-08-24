class HomeController < ApplicationController
  require 'net/imap'

  def index
  end

  def fetch_email
    unless params[:mailbox] || params[:q]
      
      omniauth = request.env['omniauth.auth']
      if omniauth.present?
        params[:email] = omniauth.info.email
        params[:password] = omniauth.credentials.token
        params[:client] = 'imap.gmail.com'
      end

      begin
        @imap = Net::IMAP.new(params[:client], 993, usessl = true, certs = nil, verify = false)
        omniauth.present? ? @imap.authenticate('XOAUTH2', params[:email], params[:password]) : @imap.login(params[:email], params[:password])
        @imap.select('Inbox') 
        @start_from = params[:start].present? ? params[:start].to_i : 0
        @end_to =  params[:end].present? ? params[:end].to_i : 10
        @mailbox = current_user.mailboxes.create(email: params[:email], password: params[:password], client: params[:client], username: params[:email].split("@")[0], login_through_gmail: omniauth.present? ? true : false)
      rescue => error
        redirect_to root_path, flash: {error: error}
      end
    end
    @q = current_user.mailboxes.ransack(params[:q])
    @mailboxes = @q.result(distinct: true)
  end

end
