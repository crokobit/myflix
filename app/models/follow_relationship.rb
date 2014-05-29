class FollowRelationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates_uniqueness_of :follower, scope: :followed
  validate :not_follow_self?
  
  
  def not_follow_self?
    if self.follower == self.followed 
      errors.add(:user, "can not follow self")
    end
  end
end
