class SessionsController < ApplicationController
  include ApplicationHelper
  def create
    debugger
    get_params = request.env["omniauth.params"]
    invite = get_params["invite"]
    @omniauth = request.env['omniauth.auth']
    if @omniauth.provider == 'google'
      email = @omniauth.extra.id_info.email
    else
      email = @omniauth.info.email
    end
    name = @omniauth.info.name
    provider_id = @omniauth.uid
    provider = @omniauth.provider
    user_image = @omniauth.info.image
    user = User.where(:email => email).first

    if user.present?
      sign_in :user, user
      begin
        if user.avatar.attached?
          user.update_attributes(:avatar => user_image) # update user profile image
        end
      rescue Exception => e
      end
      user.update_attributes(social_login: true)
      redirect_to dashboard_path, notice: I18n.t(:successfully_signin)
    else
      user = User.create(:name => name, :email => email, :password => provider_id, social_login: true,
                         referral: Devise.friendly_token)

      if invite.present?
        user_invited = User.find_by_email(invite)
        if user_invited
          point = Point.where(invitee: "Invitation accepted by #{user.name}")
          unless point.any?
            point = insert_points(user_invited.id, 6, "Invitation accepted by #{user.name}")
            user_invited.add_points!(point.point_value) unless point.errors.any?
            point = insert_points(user.id, 6, "Accepted the invitation of #{user_invited.name}")
            user.add_points!(point.point_value) unless point.errors.any?
            UserMailer.referral_sign_up(user_invited, user).deliver_later
          end
        end
      end
      begin
      UserMailer.user_sign_up(user).deliver_later
      rescue
      end
      initiate_shopify_session
      customer = ShopifyAPI::Customer.search(query:"email:#{user.email}")
      if customer.nil?
        customer = ShopifyAPI::Customer.new
        customer.email = "#{user.email}"
        customer.first_name = user.name
        customer.last_name = ''
        customer.metafields = [{key: "image_url", namespace: "global", value: '', value_type: "string"}]
        customer.save
      end
      clear_shopify_session
      sign_in :user, user
      begin

        current_user.update_attributes(:avatar => user_image) # update user profile image
      rescue Exception => e
      end
      redirect_to dashboard_path, notice: I18n.t(:successfully_signed_up)
    end

  end


  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'destroy session'
  end

end
