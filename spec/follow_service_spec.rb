require 'spec_helper'

describe FollowService do 

  def app
    FollowService::App
  end

  describe "version system" do

    it "has a version number" do
      expect(FollowService::VERSION).to_not be nil
    end

    it "cannot be used without a specified version number" do
      get 'users/1/followers'
      expect(last_response.status).to eq 401
    end

    it "cannot be used with the wrong version number" do
      binding.pry
      # header "FOLLOW_API_VERSION", "0.0.-1"
      header "Accept", "application/follow_service_api_v0.0.-1+json"
      get 'users/1/followers'
      expect(last_response.status).to eq 401
    end

  end

  describe "RESTful route usage" do 
    
    before do

      header "Accept", "application/follow_service_api_v0.0.0+json"
      # header "FOLLOW_API_VERSION", "0.0.0"

      @fry = FollowService::User.create!()
      @keith = FollowService::User.create!()
      @gaga = FollowService::User.create!()
      @barry = FollowService::User.create!()

      @keith.followees << @fry
      @keith.followees << @gaga
      @gaga.followees << @fry
      @gaga.followers << @fry

    end

    describe "following a user" do

      before do
        id = @keith.id.to_s
        post ('users/' + id + '/follow'), { followee_id: @fry.id }
      end

      it "returns a status code of 201" do
        expect(last_response.status).to eq(201)
      end

      it "saves the follow in the db" do
        expect(FollowService::Follow.count).to eq(5)
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

      it "returns JSON of all a user's followers" do 
        id = @fry.id.to_s
        get "/users/" + id + "/followers"

        expect(last_response.content_type).to eq('application/json')
        json = JSON(last_response.body)

        expect(json.length).to eq 2
        expect(json.first["id"]).to eq @keith.id
        expect(json.last["id"]).to eq @gaga.id
      end

      it "returns JSON of all a user's followees" do 
        id = @fry.id.to_s
        get "/users/" + id + "/followees"

        expect(last_response.content_type).to eq('application/json')
        json = JSON(last_response.body)

        expect(json.length).to eq 1
        expect(json.first["id"]).to eq @gaga.id
      end
    end

    describe "followers being cached with eTag" do

      before do 
        id = @fry.id.to_s
        get "/users/" + id + "/followers"

        @last_etag = last_response["Etag"]

        @id = @fry.id.to_s
        get "/users/" + @id + "/followers", {}, { "HTTP_IF_NONE_MATCH" => @last_etag } 
      end

      it "returns an etag" do 
        expect(@last_etag).to_not be nil
      end

      it "returns a 304 status if the request is repeated and followers list hasn't changed" do
        expect(last_response.status).to eq 304
        expect(last_response.body).to eq ""
      end

      it "still returns 304 if there are changes to to Follows which affect a different section of data" do
        post ('users/' + @id + '/follow'), { followee_id: @barry.id }

        # Fry has followed another person but has unchanged followers.
        get "/users/" + @id + "/followers", {}, { "HTTP_IF_NONE_MATCH" => @last_etag }

        expect(last_response.status).to eq 304
        expect(last_response.body).to eq ""
      end

      it "returns data again when there is a new follower" do
        post ('users/' + @barry.id.to_s + '/follow'), { followee_id: @id }
        get "/users/" + @id + "/followers", {}, { "HTTP_IF_NONE_MATCH" => @last_etag }

        expect(last_response.status).to eq 201
        json = JSON(last_response.body)

        expect(json.last["id"]).to eq @barry.id
      end

      describe "performance characteristics" do

        it "etags efficiently when a user has 1,000,000 followers" do
          FollowService::Follow.connection.execute "
              INSERT INTO follows(followee_id, follower_id, created_datetime)
              SELECT #{@fry.id}, #{@keith.id}, current_timestamp FROM generate_series(1,100000);
            "
          binding.pry
          get "/users/" + @id + "/followers"
          @last_etag = last_response["Etag"]
          binding.pry
          get "/users/" + @id + "/followers", {}, { "HTTP_IF_NONE_MATCH" => @last_etag }


        end
      end
    end
  end
end
