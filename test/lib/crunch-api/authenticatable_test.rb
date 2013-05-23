require_relative '../../test_helper'

describe CrunchApi::Authenticatable do

  before do
    @object = Object.new
    @object.extend(CrunchApi::Authenticatable)

    CrunchApi.configure do |config|
      config.consumer_key = "consumer_key"
      config.consumer_secret = "consumer_secret"
      config.oauth_token = "oauth_token"
      config.oauth_token_secret = "oauth_token_secret"
      config.endpoint = "https://demo.crunch.co.uk"
    end
  end

  after do
    CrunchApi.reset!
  end

  it "should return a valid OAuth token" do
    token = @object.token

    token.must_be_kind_of OAuth::AccessToken
    token.consumer.key.must_equal "consumer_key"
    token.consumer.secret.must_equal "consumer_secret"
    token.consumer.site.must_equal "https://demo.crunch.co.uk"
    token.token.must_equal "oauth_token"
    token.secret.must_equal "oauth_token_secret"

    puts token.public_methods
  end
end