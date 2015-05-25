require "wsse"
require "httparty"
require "hashie"
require "mpayer/version"
require "mpayer/configuration"
require "mpayer/fetch"
require "mpayer/endpoints/endpoint"
require "mpayer/endpoints/client"
require "mpayer/endpoints/transaction"
require "mpayer/endpoints/account"
require "mpayer/endpoints/payable"

begin
	require "pry"
rescue LoadError
end

module Mpayer
	class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

	def self.setup
		yield(configuration)
  end

  def self.login
  	Mpayer::Fetch.post('/login',post: {user_no: ENV['MPAYER_USER'],password:ENV['MPAYER_PASSWORD']}.to_json)
  end

end
