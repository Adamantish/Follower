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

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
