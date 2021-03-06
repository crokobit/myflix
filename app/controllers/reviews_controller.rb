class ReviewsController < ApplicationController

  before_action :require_user, only: [:create]

  def create
    video = Video.find(params[:video_id])
    @review = Review.new(review_params)
    if @review.save
      redirect_to video
    else
      flash[:danger] = "must give rating" if not_rating?
      flash[:danger] = "Can not rating twice !!" if user_already_reviewed?
      redirect_to video
    end
  end

  def update
    
  end

  private

  def flash_danger_message
    if not_rating?
      flash[:danger] = "must give rating" 
    elsif user_already_reviewed?
      flash[:danger] = "Can not rating twice !!" 
    else
      flash[:danger] = "should not be here"
    end

  end

  def review_params
    params.require(:review).permit(:rating, :review_description).merge(user_id: current_user.id, video_id: params[:video_id])
  end
  
  def user_already_reviewed?
    Review.find_by(video_id: params[:video_id], user: current_user)
  end

  def not_rating?
    params[:review][:rating].empty?
  end
end
