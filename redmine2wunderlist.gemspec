# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redmine2wunderlist/version'

Gem::Specification.new do |spec|
  spec.name          = "redmine2wunderlist"
  spec.version       = Redmine2wunderlist::VERSION
  spec.authors       = ["Jeremy Cronk"]
  spec.email         = ["jcronk@nxtechcorp.com"]
  spec.summary       = %q{Synchronize my open Redmine tasks with Wunderlist}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "fog", "1.19.0"
  spec.add_dependency "fog-wunderlist"
  spec.add_dependency "rest_client"
  spec.add_dependency "json"

end
