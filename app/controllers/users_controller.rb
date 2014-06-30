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
    service = SignUpService.new(@user, params[:invite_token], params[:stripeToken])

    if @user.valid?
      service.pay_via_stripe
      if service.pay_successful? && @user.save
        service.deal_with_invitation


        service.send_regisiter_success_email
        redirect_to videos_path
      else
        render :new
      end
    elsif
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
  def user_param
    params.require(:user).permit(:name, :password, :email)
  end
end
