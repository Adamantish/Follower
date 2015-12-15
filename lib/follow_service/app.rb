class FollowService::App < Sinatra::Base

  set :db_config, YAML.load_file('db/config.yml')

  configure(:development) do 
    ActiveRecord::Base.establish_connection(db_config["development"])    
  end

  configure(:test) do
    ActiveRecord::Base.establish_connection(db_config["test"])
  end

  post '/follows' do
    follow = FollowService::Follow.create!(
      follower_id: params["follower_id"],
      followed_id: params["followed_id"]
    )

    content_type :json
    [201, follow.to_json]
  end

end