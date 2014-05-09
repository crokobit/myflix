class User < ActiveRecord::Base
  has_secure_password validations: false
  validates :password, presence: true
  validates :name, presence: true
  validates :email, presence: true
  
  has_many :reviews, order: "created_at DESC"
  has_many :queue_items

  has_many :follower_followed_relationships, class_name: 'FollowRelationship', foreign_key: 'follower_id'
  has_many :following_users, through: :follower_followed_relationships, source: :followed

  has_many :followed_follower_relationships, class_name: 'FollowRelationship', foreign_key: 'followed_id'
  has_many :followed_me_users, through: :followed_follower_relationships, source: :follower
  has_one :pw_reset

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
end
