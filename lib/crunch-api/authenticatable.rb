require 'oauth'

module CrunchApi
  module Authenticatable
    def token
      options = {
          site: CrunchApi.options[:endpoint]
      }

      consumer = OAuth::Consumer.new(CrunchApi.options[:consumer_key], CrunchApi.options[:consumer_secret], options)
      OAuth::AccessToken.new(consumer, CrunchApi.options[:oauth_token], CrunchApi.options[:oauth_token_secret])
    end
  end
end