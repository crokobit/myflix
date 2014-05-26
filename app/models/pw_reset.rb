class PwReset < ActiveRecord::Base
  include Tokenable
  belongs_to :user
  validates_uniqueness_of :user_id

end
