class AppMailer < ActionMailer::Base
  default :from => "crokobit.web.deviss@gmail.com"  


  def notify_on_regisiter(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Thanks for regisiter!!"
    # mail form: 'crosdadbit@gmail.com', to: @user.email, subject: "Thanks for regisiter!!" FAIL!!!
  end

  def notify_pw_reset_link(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "Reset pw"
  end

  def notify_invitation_link(invite_user_token)
    @invite_user = InviteUser.find_by(token: invite_user_token)
    mail to: @invite_user.recipient_email,subject: "invitation"
  end

  def notify_customer_failed_subscription(customer_token)
    @customer = User.find_by(customer_token: customer_token)
    mail to: @customer.email, subject: "charge.failed"
  end


end
