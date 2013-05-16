module CrunchApi
  module Default
    ENDPOINT = 'https://crunch.co.uk' unless defined? CrunchApi::Default::ENDPOINT

    class << self
      def options
        Hash[CrunchApi.keys.map { |key| [key, send(key)] }]
      end

      def consumer_key
        ENV['CRUNCH_CONSUMER_KEY']
      end

      def consumer_secret
        ENV['CRUNCH_CONSUMER_SECRET']
      end

      def oauth_token
        ENV['CRUNCH_OAUTH_TOKEN']
      end

      def oauth_token_secret
        ENV['CRUNCH_OAUTH_TOKEN_SECRET']
      end

      def endpoint
        ENDPOINT
      end
    end
  end
end