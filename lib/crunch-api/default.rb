module CrunchApi
  module Default
    ENDPOINT = 'https://crunch.co.uk' unless defined? CrunchApi::Default::ENDPOINT

    class << self
      def options
        Hash[CrunchApi.keys.map{|key| [key, send(key)]}]
      end

      def consumer_key
        ENV['TWITTER_CONSUMER_KEY']
      end

      def consumer_secret
        ENV['TWITTER_CONSUMER_SECRET']
      end

      def oauth_token
        ENV['TWITTER_OAUTH_TOKEN']
      end

      def oauth_token_secret
        ENV['TWITTER_OAUTH_TOKEN_SECRET']
      end

      def endpoint
        ENDPOINT
      end
    end
  end
end