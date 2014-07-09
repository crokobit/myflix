class Payment < ActiveRecord::Base
  belongs_to :customer, class_name: :User
end
