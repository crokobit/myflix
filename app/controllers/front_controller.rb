class FrontController < ApplicationController
  def index
    redirect_to videos_path if logged_in?    
  end
end
