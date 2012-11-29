require 'httparty'
require 'json'

module GTAPI
  class GaptoolServer
    include HTTParty

    def initialize(user, apikey, uri)
      @auth = { 'X-GAPTOOL-USER' => user, 'X-GAPTOOL-KEY' => apikey}
      self.base_uri uri
    end

    def getonenode(role, environment, id)
      options = {:headers => @auth}
      JSON::parse self.class.get("/host/#{role}/#{environment}/#{id}", options)
    end

    def getenvroles(role, environment)
      options = {:headers => @auth}
      JSON::parse self.class.get("/hosts/#{role}/#{environment}", options)
    end

    def addnode(zone, itype, role, environment)
      @body = {
        'zone' => zone,
        'itype' => itype,
        'role' => role,
        'environment' => environment,
      }.to_json
      options = { :body => @body, :headers => @auth}
      JSON::parse self.class.post("/init", options)
    end

    def terminatenode(id, zone)
      @body = {'id' => id, 'zone' => zone}.to_json
      options = {:body => @body, :headers => @auth}
      JSON::parse self.class.post("/terminate", options)
    end

    def ssh(role, environment, id)
      options = { :headers => @auth}
      JSON::parse self.class.get("/ssh/#{role}/#{environment}/#{id}", options)
    end
  end
end
