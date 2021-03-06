class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :require_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end
  def new_user_via_invitation
    @invite_user = InviteUser.find_by(token: params[:token])
    @user = User.new(email: @invite_user.recipient_email)
    render '_form_partial'
  end

  def create
    @user = User.new(user_param)
    service = SignUpService.new(@user, params[:stripeToken], params[:invite_token]).sign_up

    if service.status == :success
      redirect_to videos_path
    else
      flash[:danger] = service.error_message
      render :new
    end
    
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit; end
  
  def update
    if password_confirmation? && @user.update(user_param) 
      redirect_to root_path
      flash[:success] = "update success"
    elsif password_confirmation? == false
      flash[:danger] = "password confirmation failed"
      render :edit
    else
      flash[:danger] = "invalid update"
      render :edit
    end
  end

  def set_user
    @user = User.find(params[:id])
  end


  private
  def password_confirmation?
    params[:user][:password] == params[:user][:password_confirmation] 
  end
  def user_param
    params.require(:user).permit(:name, :password, :email)
  end
end
