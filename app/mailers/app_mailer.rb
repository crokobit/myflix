class AppMailer < ActionMailer::Base
  default :from => "foobar@example.org"  

  def notify_on_regisiter(user)
    @user = user
    mail to: @user.email, subject: "Thanks for regisiter!!"
    # mail form: 'crosdadbit@gmail.com', to: @user.email, subject: "Thanks for regisiter!!" FAIL!!!
  end
end
