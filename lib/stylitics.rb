require 'httparty'
require "stylitics/version"

module Stylitics

  module Config
    attr_accessor :auth_token

    def configure
      yield self
      self
    end
  end

  ####################

  class Client

    BASE_URL = "https://www.stylitics.com/api/v1/external"

    extend ::Stylitics::Config

    attr_accessor :auth_token

    def initialize(opts={})
      @auth_token = self.class.auth_token || opts[:auth_token]

      if !@auth_token
        raise AuthenticationError,
        "Must provide an auth token through config block or options"
      end
    end

    def outfits
      resp = get '/outfits'
      JSON.parse(resp.body)
    end

    def collages(ids)
      qs = ids.map do |id|
        "ids[]=#{id}"
      end.join("&")
      HTTParty.get(BASE_URL + '/collage_items' + "?auth_token=#{auth_token}&#{qs}")
    end

    #items is broken

    private

    def get(path)
      HTTParty.get(BASE_URL + path + "?auth_token=#{auth_token}")
    end

  end

end
