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
end
