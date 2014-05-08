class PwResetsController < ApplicationController

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
      flash[:success] = "pw reset success"
      redirect_to root_path
    else
      #unsure
      redirect_to reset_pw_path(id: params[:token])
    end
  end

  def create
    user = User.find_by(email: params[:email])
    binding.pry
    if user.nil?
      flash[:error] = "no such user"
      render :enter_email
    else
      user.create_pw_reset
      send_email(user)
      render 'enter_email_success'
    end
  end

  def send_email(user)
    AppMailer.notify_pw_reset_link(user).deliver
  end

  def enter_email; end


end
