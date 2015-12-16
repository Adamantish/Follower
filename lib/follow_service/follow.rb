
class FollowService::Follow < ActiveRecord::Base

  belongs_to :follower, class_name: "User", foreign_key: "follower_id"
  belongs_to :followee, class_name: "User", foreign_key: "followee_id"

  scope :latest, lambda { maximum(:created_datetime) }

  before_save :set_created_date

  private

  def set_created_date
    self.created_datetime = Time.now
  end

end