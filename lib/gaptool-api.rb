require 'httparty'
require 'json'

module GTAPI
  class GaptoolServer
    include HTTParty
    default_timeout 600

    def initialize(user, apikey, uri)
      @auth = { 'X-GAPTOOL-USER' => user, 'X-GAPTOOL-KEY' => apikey}
      GaptoolServer.base_uri uri
    end

    def mongocollectioncount(hash)
      options = {:body => hash, :headers => @auth}
      JSON::parse self.class.post("/status/mongo/colcount", options)
    end

    def remoteredisllen(list)
      options = {:body => list, :headers => @auth}
      JSON::parse self.class.post("/status/redis/llen", options)
    end

    def remoteredislpush(list, value)
      @body = {'list' => list, 'value' => value}.to_json
      options = {:body => @body, :headers => @auth}
      JSON::parse self.class.post("/status/redis/lpush", options)
    end

    def redishash(hash)
      options = {:body => hash, :headers => @auth}
      JSON::parse self.class.post("/redishash", options)
    end

    def getonenode(id)
      options = {:headers => @auth}
      JSON::parse self.class.get("/instance/#{id}", options)
    end

    def getenvroles(role, environment)
      options = {:headers => @auth}
      JSON::parse self.class.get("/hosts/#{role}/#{environment}", options)
    end

    def addnode(zone, itype, role, environment, mirror=0)
      if mirror == 0
        @body = {
          'zone' => zone,
          'itype' => itype,
          'role' => role,
          'environment' => environment,
        }.to_json
      else
        @body = {
          'zone' => zone,
          'itype' => itype,
          'role' => role,
          'environment' => environment,
          'mirror' => mirror,
        }.to_json
      end
      options = { :body => @body, :headers => @auth}
      JSON::parse self.class.post("/init", options)
    end

    def terminatenode(id, zone)
      @body = {'id' => id, 'zone' => zone}.to_json
      options = {:body => @body, :headers => @auth}
      JSON::parse self.class.post("/terminate", options)
    end

    def getappnodes(app, environment)
      options = {:headers => @auth}
      role = JSON::parse(self.class.get("/apps", options))["app:#{app}"]['role']
      JSON::parse self.class.get("/hosts/#{role}/#{environment}", options)
    end

    def ssh(role, environment, id)
      options = { :headers => @auth}
      JSON::parse self.class.get("/ssh/#{role}/#{environment}/#{id}", options)
    end

    def regenhosts(zone)
      @body = {'zone' => zone}.to_json
      options = {:body => @body, :headers => @auth}
      JSON::parse self.class.post("/regenhosts", options)
    end

    def addservice(role, environment, name, keys, weight, enabled)
      @body = {
        'name' => name,
        'keys' => keys,
        'weight' => weight,
        'enabled' => enabled,
        'role' => role,
        'environment' => environment
      }.to_json
      options = {:body => @body, :headers => @auth}
      # output is service count
      JSON::parse self.class.put("/service/#{role}/#{environment}", options)
    end

    def deleteservice(role, environment, name)
      options = { :headers => @auth}
      # output is service count
      JSON::parse self.class.delete("/service/#{role}/#{environment}/#{name}", options)
    end

    def balanceservices(role, environment)
      options = { :headers => @auth}
      # output is runlist
      JSON::parse self.class.get("/servicebalance/#{role}/#{environment}", options)
    end

    def getservices()
      options = { :headers => @auth}
      # output is all service entries
      JSON::parse self.class.get("/services", options)
    end

    def getrolenodes(role)
      options = { :headers => @auth}
      JSON::parse self.class.get("/hosts/#{role}", options)
    end

    def getenvnodes(environment)
      options = { :headers => @auth}
      JSON::parse self.class.get("/hosts/ALL/#{environment}", options)
    end

    def getallnodes()
      options = { :headers => @auth}
      JSON::parse self.class.get("/hosts", options)
    end

    def svcapi_getkey(service)
      options = { :headers => @auth}
      JSON::parse self.class.get("/servicekeys/use/#{service}", options)
    end

    def svcapi_releasekey(service,key)
      options = {:body => {"key" => key}.to_json , :headers => @auth}
      JSON::parse self.class.post("/servicekeys/release/#{service}", options)
    end

    def svcapi_showkeys(service)
      options = { :headers => @auth}
      unless service == :all
        JSON::parse self.class.get("/servicekeys/#{service}", options)
      else
        JSON::parse self.class.get("/servicekeys", options)
      end
    end

    def svcapi_deletekey(service, key)
      options = {:body => {"key" => key}.to_json , :headers => @auth}
      JSON::parse self.class.delete("/servicekeys/#{service}", options)
    end

    def svcapi_putkey(service, key)
      options = {:body => {"key" => key}.to_json , :headers => @auth}
      JSON::parse self.class.put("/servicekeys/#{service}", options)
    end
  end
end
