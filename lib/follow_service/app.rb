class FollowService::App < Sinatra::Base
  
  include ActiveSupport::Inflector

  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end
  
  set :db_config, YAML.load_file('db/config.yml')

  configure(:development) do 
    ActiveRecord::Base.establish_connection(db_config["development"])    
  end

  configure(:test) do
    ActiveRecord::Base.establish_connection(db_config["test"])
  end

  before do
    cross_origin

    # unless env["HTTP_FOLLOW_API_VERSION"] == FollowService::VERSION
    #   halt 401, {'Content-Type' => 'text/plain'}, "Be sure to set the Follow Service API version to #{FollowService::VERSION} in the headers"
    # end
  end

  options "*" do 
    # require 'pry'
    # binding.pry
    allowed_origins = ["http://localhost:3000", "http://localhost:8888"]
    request_origin = response.headers["Access-Control-Allow-Origin"]

    if allowed_origins.include? request_origin
      response.headers["Access-Control-Allow-Origin"] = request_origin
    end
    
    response.headers["Allow"] = "GET,POST,OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Accept"
  end

  delete '/users/:followee_id/follow' do |followee_id|

    require 'pry'
    binding.pry
     # temp hardcode
    follower_id = params["follower_id"] || 2

    delete_me = FollowService::Follow.where(follower_id: follower_id, followee_id: followee_id).id
    FollowService::Follow.destroy(delete_me)
  end

  post '/users/:followee_id/follow' do |followee_id|
    require 'pry'

    binding.pry
    # temp hardcode
    follower_id = params["follower_id"] || 2

    follow = FollowService::Follow.find_or_create_by(
      followee_id: FollowService::User.find_or_create_by(id: followee_id ).id,
      follower_id: FollowService::User.find_or_create_by(id: follower_id ).id
    )

    # TODO: put this in a helper
    camel_follow = {}
    follow.attributes.map do |key, val|
      camel_follow[key.camelize(:lower)] = val
    end
    
    follow = camel_follow.to_json

    content_type :json
    [201, follow]
  end

  get '/users/:id/follow' do
    # Currently this is just an alias of get followERs
    id = params['id']
    user = FollowService::User.find(id)

    latest = user.follows_of_me.latest
    count = user.follows_of_me.count

    etag latest.to_s + count.to_s

    json_followers = user.followers.to_json

    ## if this were being paged I'd etag the digest of the page instead. 
    # etag Digest::SHA1.digest(json_followers)

    content_type :json
    [200, json_followers]
  end

# TODO: put this functionality into a version of the GET follow route with query string to distinguish
  get '/users/:id/followees' do

    id = params['id']
    user = FollowService::User.find(id)
    latest = user.follows_from_me.latest
    count = user.follows_from_me.count
    
    etag latest.to_s + count.to_s
    
    followees = user.followees

    content_type :json
    [200, followees.to_json]

  end

end