module AdminVideosHelper
  def options_for_category
    options_for_select( Category.all.map {|category| [category.name, category.id]} )
  end
end
