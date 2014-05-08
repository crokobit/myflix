class PwReset < ActiveRecord::Base
  belongs_to :user
  before_save :generate_token
  validates_uniqueness_of :user_id

  def generate_token
    self.token = SecureRandom.base64
  end

  def to_param
    generate_token
  end

end
