class Relationship < ApplicationRecord
  belong_to :follower, class_name: "User"
  belong_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
