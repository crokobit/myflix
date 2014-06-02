class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :require_user, only: [:show]

  def new
    #binding.pry
    @user = User.new
  end
  def new_user_via_invitation
    @invite_user = InviteUser.find_by(token: params[:token])
    @user = User.new(email: @invite_user.recipient_email)
    render '_form_partial'
  end
  def create
    @user = User.new(user_param)
    if @user.save
      session[:user_id] = @user.id
      deal_with_invitation unless invitor.nil?
      AppMailer.notify_on_regisiter(current_user).deliver
      redirect_to videos_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit; end
  
  def update
    if @user.update(user_param)
      redirect_to root_path
    else
      flash[:danger] = "invalid update"
      render :edit
    end
  end

  def set_user
    @user = User.find(params[:id])
  end


  private
  def deal_with_invitation
    invite_user = InviteUser.find_by(token: params[:token])
    @user.following_each_other_with(invitor)
    InviteUser.destroy_all_invitations_to(invite_user.recipient_email)
  end
  def user_param
    params.require(:user).permit(:name, :password, :email)
  end
  def invitor
    invite_user = InviteUser.find_by(token: params[:token])
    invite_user.try(:invitor)
  end
end
