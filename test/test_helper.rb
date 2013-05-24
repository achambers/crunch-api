require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'vcr'
require File.expand_path('../../lib/crunch-api', __FILE__)

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<Authorization>') do |interaction|
    interaction.request.headers['Authorization'].first
  end
end