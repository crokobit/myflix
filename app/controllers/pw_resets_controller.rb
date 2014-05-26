class PwResetsController < ApplicationController

  def enter_email; end
  
  #after enter_email, create token and send it here
  def create
    user = User.find_by(email: params[:email])
    if user.nil?
      flash[:danger] = "no such user"
      render :enter_email
    else
      user.create_pw_reset
      user.reload
      send_email(user)
      render 'enter_email_success'
    end
  end

  def send_email(user)
    AppMailer.notify_pw_reset_link(user).deliver
  end

  # /pw_resets/token to here
  def show
    @user = PwReset.find_by(token: params[:id]).try(:user)
    if @user.nil?
      redirect_to root_path 
    else
      render 'reset_pw'
    end
  end

  def reset_pw
    pw_reset = PwReset.find_by(token: params[:token])
    user = pw_reset.user
    if user.change_pw_to(params[:password])
      user.pw_reset.destroy
      flash[:success] = "password reset success"
      redirect_to root_path
    else
      #unsure
      redirect_to pw_reset_path(user.pw_reset)
    end
  end

end
