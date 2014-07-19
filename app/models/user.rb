class User < ActiveRecord::Base
  has_secure_password validations: false
  validates :password, presence: true
  validates :name, presence: true
  validates :email, presence: true
  
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items

  has_many :follower_followed_relationships, class_name: 'FollowRelationship', foreign_key: 'follower_id'
  has_many :following_users, through: :follower_followed_relationships, source: :followed

  has_many :followed_follower_relationships, class_name: 'FollowRelationship', foreign_key: 'followed_id'
  has_many :followed_me_users, through: :followed_follower_relationships, source: :follower
  has_one :pw_reset
  has_many :invite_users

  has_many :payments

  def have_pw_reset?
    !!pw_reset
  end

  def create_pw_reset
    pw_reset.destroy if have_pw_reset?
    PwReset.create(user: self)
  end

  def change_pw_to(pw)
    #has_secure_password validations: false
    # lead to self.update always return true ??!!!
    self.update(password: pw)
    pw.blank? ? false : true
  end

  def is_following(followed)
    self.following_users << followed 
  end

  def following_each_other_with(another_user)
    self.is_following(another_user)
    another_user.is_following(self)
  end

  def can_follow?(another_user)
    FollowRelationship.new(follower: self, followed: another_user).valid? 
  end

  def is_admin?
    admin
  end
end
