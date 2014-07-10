class Admin::VideosController < AdminsController
  before_action :require_user
  def new
    @video = Video.new
  end

  def create
    @video = Video.create(admin_video_param)
    if @video.save
      flash[:success] = "video be created successfully"
      redirect_to root_path
    else
      flash[:danger] = "video not be created"
      render :back
    end
  end

  private
  def admin_video_param
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :url)
  end
end
