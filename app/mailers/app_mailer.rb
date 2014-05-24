class AppMailer < ActionMailer::Base
  default :from => "foobar@example.org"  

  def notify_on_regisiter(user)
    @user = user
    mail to: @user.email, subject: "Thanks for regisiter!!"
    # mail form: 'crosdadbit@gmail.com', to: @user.email, subject: "Thanks for regisiter!!" FAIL!!!
  end

  def notify_pw_reset_link(user)
    @user = user
    mail to: @user.email, subject: "Reset pw"
  end

  def notify_invitation_link(invite_user)
    @invite_user = invite_user
    mail to: invite_user.recipient_email,subject: "invitation"
  end
end
