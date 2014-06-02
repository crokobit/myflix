class InviteUsersController < ApplicationController
  before_action :require_user, only: [:new, :create, :new_user]
  def new
    @invite_user = InviteUser.new
  end
  def create
    @invite_user = InviteUser.new(invite_user_param)
    if @invite_user.save && not_regisitered_yet?(@invite_user.recipient_email)
      send_email(@invite_user)
      render 'invitation_success'
    else 
      flash[:danger] = "recipient already regisitered"
      render :new
    end
  end
  # email link here
  # create new user
  def show
    @invite_user = InviteUser.find_by(token: params[:id])
    if @invite_user
      redirect_to new_user_via_invitation_path(token: @invite_user.token)
    else
      flash[:danger] = "link is expired"
      redirect_to root_path
    end
  end
  private

  def invite_user_param
    params.require(:invite_user).permit(:recipient_name, :recipient_email, :recipient_message).merge!(invitor: current_user)
  end

  def send_email(invite_user)
    AppMailer.notify_invitation_link(invite_user).deliver
  end
  
  def not_regisitered_yet?(email)
    !User.find_by(email: email) 
  end
end
