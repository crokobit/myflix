class SignUpService
  def  initialize(user, invite_token, stripe_token)
    @user = user
    @invite_token = invite_token
    @invitor = invitor
    @stripe_token = stripe_token
  end


  def pay_via_stripe
    @stripe_response = StripeWrapper::Charge.create(
      :amount => 1000, # amount in cents, again
      :card => @stripe_token
    )
  end

  def pay_successful?
    @stripe_response.successful?
  end

  def send_regisiter_success_email
    AppMailer.delay.notify_on_regisiter(@user.id)
  end

  def deal_with_invitation
    unless @invite_token.blank?
      invite_user = InviteUser.find_by(token: @invite_token)
      @user.following_each_other_with(@invitor)
      InviteUser.destroy_all_invitations_to(invite_user.recipient_email)
    end
  end

  private

  def invitor
    invite_user = InviteUser.find_by(token: @invite_token)
    invite_user.try(:invitor)
  end

end
