require_relative '../test_helper'

describe CrunchApi do

  describe "configuration" do
    after do
      CrunchApi.reset!
    end

    [:consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret, :endpoint].each do |key|
      it "must set the attribute for #{key}" do
        CrunchApi.configure do |config|
          config.send("#{key}=", "foo")
        end

        CrunchApi.instance_variable_get(:"@#{key}").must_equal "foo"
      end
    end
  end

end