require_relative '../../test_helper'

describe CrunchApi::Default do

  before do
    @consumer_key = ENV['CRUNCH_CONSUMER_KEY']
    ENV['CRUNCH_CONSUMER_KEY'] = "foo"

    @consumer_secret = ENV['CRUNCH_CONSUMER_SECRET']
    ENV['CRUNCH_CONSUMER_SECRET'] = "bar"

    @oauth_token = ENV['CRUNCH_OAUTH_TOKEN']
    ENV['CRUNCH_OAUTH_TOKEN'] = "woo"

    @oauth_token_secret = ENV['CRUNCH_OAUTH_TOKEN_SECRET']
    ENV['CRUNCH_OAUTH_TOKEN_SECRET'] = "war"
  end

  after do
    ENV['CRUNCH_CONSUMER_KEY'] = @consumer_key
    ENV['CRUNCH_CONSUMER_SECRET'] = @consumer_secret
    ENV['CRUNCH_OAUTH_TOKEN'] = @oauth_token
    ENV['CRUNCH_OAUTH_TOKEN_SECRET'] = @oauth_token_secret
  end

  describe "environment variables" do
    it "returns the consumer key" do
      CrunchApi::Default.consumer_key.must_equal "foo"
    end

    it "returns the consumer secret" do
      CrunchApi::Default.consumer_secret.must_equal "bar"
    end

    it "returns the oauth token" do
      CrunchApi::Default.oauth_token.must_equal "woo"
    end

    it "returns the oauth token secret" do
      CrunchApi::Default.oauth_token_secret.must_equal "war"
    end
  end

end