require_relative 'crunch-api/version'
require_relative 'crunch-api/default'

module CrunchApi
  class << self
    attr_writer :consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret, :endpoint

    def keys
      @keys ||= [
          :consumer_key,
          :consumer_secret,
          :oauth_token,
          :oauth_token_secret,
          :endpoint
      ]
    end

    def configure
      yield self
      self
    end

    def options
      Hash[CrunchApi.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def reset!
      CrunchApi.keys.each do |key|
        instance_variable_set(:"@#{key}", CrunchApi::Default.options[key])
      end
      self
    end
    alias setup reset!
  end
end

CrunchApi.setup
