class SignUpService
  attr_reader :status, :error_message
  def initialize(user, stripe_token, invite_token)
    @user = user
    @invite_token = invite_token
    @invitor = invitor
    @stripe_token = stripe_token
    @status = nil
  end

  def sign_up
    if @user.valid?
      #pay_via_stripe
      @stripe_response = StripeWrapper::Customer.create(@user, @stripe_token)
      if pay_successful? && @user.save
        @user.update(active: true, admin: false)
        deal_with_invitation
        send_regisiter_success_email
        @user.customer_token = @stripe_response.customer_token
        @user.save


        @status = :success
        self
      else
        @status = :error
        @error_message = "user information is valid but card is invalid"
        self
      end
    else
      @status = :error
      @error_message = "user information is invalid"
      self

    end
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
