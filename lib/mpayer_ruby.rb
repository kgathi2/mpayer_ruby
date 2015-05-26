require "wsse"
require "httparty"
require "hashie"
require "mpayer_ruby/version"
require "mpayer_ruby/configuration"
require "mpayer_ruby/fetch"
require "mpayer_ruby/endpoints/endpoint"
require "mpayer_ruby/endpoints/client"
require "mpayer_ruby/endpoints/transaction"
require "mpayer_ruby/endpoints/account"
require "mpayer_ruby/endpoints/payable"

# begin
#   require "pry"
# 	require "pry-alias"
# rescue LoadError
# end

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
