require "sinatra"
require "sinatra/cross_origin"
require "json"
require "active_record"
require "digest/sha1"
require 'active_support'


require "follow_service/version"
require "follow_service/follow"
require "follow_service/user"
require "follow_service/app"


module FollowService
  puts "Hello from FollowService gem"
end
