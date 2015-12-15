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

    @keith.followees << @fry
    @keith.followees << @gaga
    @gaga.followees << @fry
    
  end

  describe "following a user" do

    before do
      id = @keith.id.to_s
      post ('users/' + id + '/follow'), { follow_id: @fry.id }
    end

    it "returns a status code of 201" do
      expect(last_response.status).to eq(201)
    end

    it "saves the follow in the db" do
      expect(FollowService::Follow.count).to eq(4)
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
      id = @fry.id.to_s
      get "/users/" + id + "/followers"
    end

    it "returns JSON of all a user's followers" do 
      expect(last_response.content_type).to eq('application/json')
      json = JSON(last_response.body)
      expect(json.length).to eq 2
      expect(json.first["id"]).to eq @keith.id
      expect(json.last["id"]).to eq @gaga.id
    end
  end

end

# 1 get the POST nested in users