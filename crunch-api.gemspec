# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crunch-api/version'

fullname = `git config --get user.name`.chomp
email    = `git config --get user.email`.chomp
login    = `git config --get github.user`.chomp
gem_name = "crunch-api"

Gem::Specification.new do |spec|
  spec.name          = gem_name
  spec.version       = CrunchApi::VERSION
  spec.authors       = [ "#{fullname}" ]
  spec.email         = "#{email}"
  spec.description   = %q{A Ruby interface to the Crunch Accounting API}
  spec.summary       = spec.description
  spec.homepage      = "http://github.com/#{login}/#{gem_name}"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("oauth", "~> 0.4.7")
  spec.add_dependency("nori", "~> 2.2.0")
  spec.add_dependency("nokogiri", "~> 1.5.9")
  spec.add_dependency("dotenv", "~> 0.7.0")
  spec.add_dependency("money", "~> 5.1.1")

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr", "~>2.4"
  spec.add_development_dependency "guard", "~> 1.8.0"
  spec.add_development_dependency "guard-minitest", "~> 0.5.0"
  spec.add_development_dependency "terminal-notifier-guard", "~> 1.5.3"
  spec.add_development_dependency "m", "~> 1.3.1"
end
