class VideoDecorator < Draper::Decorator
  delegate_all
  def rating
    object.averge_rating ? "#{object.averge_rating}/5.0" : "N/A"
  end
end
