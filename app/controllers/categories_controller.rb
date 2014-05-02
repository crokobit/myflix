class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @videos = Video.where(category: @category)
  end
end
