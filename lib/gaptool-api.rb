require 'httparty'
require 'json'

module GaptoolServer
  include HTTParty
  base_uri ENV['GAPTOOL_SERVER_URI']

  def initialize(user, apikey)
    @auth = { 'X-GAPTOOL-USER' => user, 'X-GAPTOOL-KEY' => apikey}
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
