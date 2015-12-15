require 'spec_helper'

describe FollowService::User do
  
  before do
    @fry = FollowService::User.create!()
    @keith = FollowService::User.create!()
    @gaga = FollowService::User.create!()

    @keith.followees << @fry
    @keith.followees << @gaga


  end

  it "should be able to follow other users" do
    expect(@keith.followees.length).to eq 2
  end
end