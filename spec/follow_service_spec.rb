require 'spec_helper'

describe FollowService do 

  def app

    FollowService::App
  end

  it "has a version number" do
    expect(FollowService::VERSION).to_not be nil
  end

  describe "following a user" do

    before do
      post '/follows', { follower_id: 1, followed_id: 10 }
    end

    it "returns a status code of 201" do
      binding.pry
      expect(last_response.status).to eq(201)
    end

    it "saves the follow in the db" do
      expect(FollowService::Follow.count).to eq(1)
    end

    it "returns JSON of the new follow relationship" do
      expect(last_response.content_type).to eq('application/json')
      json = JSON(last_response.body)
      expect(json['follower_id']).to eq 1
      expect(json['followed_id']).to eq 10
      expect(json['id']).to_not be_nil

    end
  end
end