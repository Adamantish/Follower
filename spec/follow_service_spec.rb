require 'spec_helper'

describe FollowService do 

  def app

    FollowService::App
  end

  it "has a version number" do
    expect(FollowService::VERSION).to_not be nil
  end

  before do
    @fry = FollowService::User.create!()
    @keith = FollowService::User.create!()
    @gaga = FollowService::User.create!()
    
  end

  describe "following a user" do

    before do
      
      post ('users/' + @keith.id.to_s + '/follow'), { follow_id: @fry.id }
    end

    it "returns a status code of 201" do
      expect(last_response.status).to eq(201)
    end

    it "saves the follow in the db" do
      expect(FollowService::Follow.count).to eq(1)
    end

    it "returns JSON of the new follow relationship" do
      expect(last_response.content_type).to eq('application/json')
      json = JSON(last_response.body)
      expect(json['follower_id']).to eq @keith.id
      expect(json['followee_id']).to eq @fry.id
      expect(json['id']).to_not be_nil
    end
  end

  describe "viewing followers for a user" do 

    before do 
      get "/users/:id/followers"
    end

  end

end

# 1 get the POST nested in users