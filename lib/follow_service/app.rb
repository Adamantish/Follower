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

  post '/users/:id/follow' do

    follow = FollowService::Follow.create!(
      follower_id: params["id"],
      followee_id: params["follow_id"]
    )

    content_type :json
    [201, follow.to_json]
  end

  get '/users/:id/followers' do

    id = params['id']
    user = FollowService::User.find(id)

    # This is not foolproof. If the user were to refresh during a second when there were an equal number
    # of follows and unfollows they'd not be alerted to the change on subsequent refreshes.
    # if this were being paged I'd etag the digest of the page instead. 
    # Alternatively a more precise time measure could be used or a DB rowversion.

    latest = user.follows_of_me.latest
    count = user.follows_of_me.count

    etag latest.to_s + count.to_s

    followers = user.followers

    content_type :json
    [201, followers.to_json]
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