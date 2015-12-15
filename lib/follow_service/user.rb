class FollowService::User < ActiveRecord::Base


  has_many :follows_of_me, class_name: "Follow", foreign_key: :followee_id
  has_many :follows_from_me, class_name: "Follow", foreign_key: :follower_id

  has_many :followers, class_name: "User", through: :follows_of_me, source: :follower
  has_many :followees, class_name: "User", through: :follows_from_me, source: :followee

end