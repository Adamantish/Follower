# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'follow_service/version'

Gem::Specification.new do |spec|
  spec.name          = "follow_service"
  spec.version       = FollowService::VERSION
  spec.authors       = ["Adamantish"]
  spec.email         = ["sonsequence@hotmail.com"]
  spec.summary       = %q{A sinatra app that tracks followers in our app}
  spec.description   = %q{A RESTFul JSON HTTP API for following entities in web applications}
  spec.homepage      = "https://www.github.com/adamantish"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "json"
  spec.add_dependency "activerecord", "~> 4.0"
  spec.add_dependency "pg"
  spec.add_dependency "digest"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "active_record_migrations"
  spec.add_development_dependency "database_cleaner"
end
