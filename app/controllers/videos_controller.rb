class VideosController < ApplicationController
  before_action :require_user, only: [:show, :search, :review]

  def index
    @categories = Category.all
    redirect_to root_path if !logged_in?
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @videos = Video.search_by_title(params[:search_item])
  end

  def review
    @video = Video.find(params[:id])
    @review = Review.new(
      rating: params[:rating],
      review_description: params[:review_description],
      user: current_user,
      video: @video
    )
    if @review.save
      redirect_to @video
    else
      flash[:error] = "not success"
      redirect_to @video
    end
  end

end
