module Tokenable
  extend ActiveSupport::Concern
  included do
    before_save :generate_token
  end


  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def to_param
    self.token
  end

  module ClassMethods
  end
end
