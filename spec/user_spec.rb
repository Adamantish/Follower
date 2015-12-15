require 'spec_helper'

describe FollowService::User do
  
  before do
    @fry = FollowService::User.create!()
    @keith = FollowService::User.create!()
    @gaga = FollowService::User.create!()

    @keith.followees << @fry
    @keith.followees << @gaga
    @gaga.followees << @fry

  end

  it "should be able to follow other users" do
    expect(@keith.followees.length).to eq 2
    expect(@keith.followees.first).to eq @fry
    expect(@keith.followees.last).to eq @gaga

  end

  it "should allow other users to see who has followed them" do 
    expect(@fry.followers.length).to eq 2
    expect(@fry.followers.first).to eq @keith
    expect(@fry.followers.last).to eq @gaga
  end


end