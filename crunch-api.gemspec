# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crunch-api/version'

Gem::Specification.new do |spec|
  spec.name          = "crunch-api"
  spec.version       = CrunchApi::VERSION
  spec.authors       = ["Aaron Chambers"]
  spec.email         = ["achambers@gmail.com"]
  spec.description   = %q{A Ruby interface to the Crunch Accounting API}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("oauth", "~> 0.4.7")
  spec.add_dependency("nori", "~> 2.2.0")
  spec.add_dependency("nokogiri", "~> 1.5.9")

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr", "~>2.4"
end