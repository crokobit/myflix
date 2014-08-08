class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]

  def new
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password]) && user.active == false
      flash[:danger] = "user was deactived"
      redirect_to login_path
    elsif user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:info] = "Login success"
      redirect_to videos_path
    else
      flash[:danger] = "Login fail"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = 'logged out'
    redirect_to root_path
  end
end
