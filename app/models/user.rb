class User < ActiveRecord::Base
  has_secure_password validations: false
  validates :password, presence: true
  validates :name, presence: true
  
  has_many :reviews, order: "created_at DESC"
  has_many :queue_items
end
