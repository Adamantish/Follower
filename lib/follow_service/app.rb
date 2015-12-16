class FollowService::App < Sinatra::Base

  set :db_config, YAML.load_file('db/config.yml')

  configure(:development) do 
    ActiveRecord::Base.establish_connection(db_config["development"])    
  end

  configure(:test) do
    ActiveRecord::Base.establish_connection(db_config["test"])
  end

  before do

    unless env["HTTP_FOLLOW_API_VERSION"] == FollowService::VERSION
      halt 401, {'Content-Type' => 'text/plain'}, "Be sure to set the Follow Service API version to #{FollowService::VERSION} in the headers"
    end
  end

  post '/users/:originating_id/follow' do |originating_id|

    binding.pry
    follow = FollowService::Follow.create!(
      follower_id: FollowService::User.find_or_create_by(id: originating_id ).id,
      followee_id: FollowService::User.find_or_create_by(id: params["follow_id"] ).id
    )

    content_type :json
    [201, follow.to_json]
  end

  get '/users/:id/followers' do

    id = params['id']
    user = FollowService::User.find(id)

    # This is not foolproof. If the user were to refresh during a second when there were an equal number
    # of follows and unfollows they'd not be alerted to the change on subsequent refreshes.
    # Alternatively a more precise time measure could be used or a DB rowversion.

    latest = user.follows_of_me.latest
    count = user.follows_of_me.count

    etag latest.to_s + count.to_s

    json_followers = user.followers.to_json

    ## if this were being paged I'd etag the digest of the page instead. 
    # etag Digest::SHA1.digest(json_followers)

    content_type :json
    [201, json_followers]
  end

  get '/users/:id/followees' do

    id = params['id']
    user = FollowService::User.find(id)
    latest = user.follows_from_me.latest
    count = user.follows_from_me.count
    
    etag latest.to_s + count.to_s
    
    followees = user.followees

    content_type :json
    [201, followees.to_json]

  end

end