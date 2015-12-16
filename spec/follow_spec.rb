describe FollowService::Follow do 

  before do 

    FollowService::Follow.create!(follower_id: 1, followee_id: 2)
    FollowService::Follow.create!(follower_id: 2, followee_id: 1)
    FollowService::Follow.create!(follower_id: 1, followee_id: 3)

  end

  it "can find the time of last follow with a scope" do

    follows = FollowService::Follow.all
    last_follow = follows.latest
    FollowService::Follow.create!(follower_id: 1, followee_id: 3)
    laster_follow = follows.latest

    expect(laster_follow).to be > last_follow

  end
end