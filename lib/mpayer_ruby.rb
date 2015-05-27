require "wsse"
require "httparty"
require "hashie"
require "mpayer_ruby/version"
require "mpayer_ruby/configuration"
require "mpayer_ruby/fetch"
require "mpayer_ruby/endpoints/_endpoint"
require "mpayer_ruby/endpoints/client"
require "mpayer_ruby/endpoints/transaction"
require "mpayer_ruby/endpoints/account"
require "mpayer_ruby/endpoints/payable"
require "mpayer_ruby/endpoints/message"

# begin
#   require "pry"
# 	require "pry-alias"
# rescue LoadError
# end

module Mpayer
	class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def setup
      yield(configuration)
    end

    def login
     Mpayer::Fetch.post('/login',post: {user_no: ENV['MPAYER_USER'],password:ENV['MPAYER_PASSWORD']}.to_json)
   end
 end

end
