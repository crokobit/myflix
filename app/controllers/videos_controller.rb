class VideosController < ApplicationController
  before_action :require_user, only: [:show, :search, :create_review]

  def index
    @categories = Category.all
    redirect_to root_path if !logged_in?
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    # if @video.reviews.where(user: current_user).blank?
    #   @review = Review.new
    # elsif
    #   @review = @video.reviews.where(user: current_user)
    # end
    @rating = @video.reviews.find_by(user: current_user).try(:rating)
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_item])
  end

end
