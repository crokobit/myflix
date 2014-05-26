class FollowRelationshipsController < ApplicationController
  before_action :require_user, only: [:show, :destroy, :create]

  def show
    @follows = current_user.following_users
  end

  def destroy
    @relationship = FollowRelationship.find_by(follower: current_user, followed: User.find(params[:id]))
    @relationship.destroy
    redirect_to people_path
  end

  def create
    followed = User.find(params[:id])
    @relationship = FollowRelationship.new(follower: current_user, followed: followed)
    if @relationship.save
      flash[:success] = "follow success!"
    else
      flash[:danger] = "follow fail!"
    end
      redirect_to user_path(followed)
  end
end
