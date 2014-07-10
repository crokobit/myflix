class AdminsController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    unless current_user.try(:is_admin?)
      flash[:danger] = "You must be a admin to do that"
      redirect_to root_path
    end
  end

end
