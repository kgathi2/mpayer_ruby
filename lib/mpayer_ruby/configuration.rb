module Mpayer
	class Configuration
		attr_accessor :user_no, :token, :base_url

    def initialize(user_no:nil,token:nil)
    	@base_url = 'https://app.mpayer.co.ke/api/'
    	@user_no ||= user_no
    	@token ||= token
    end

    def auth
    	WSSE::header(user_no, token) unless user_no.nil? and token.nil?
    end

    def header
		  {'Content-Type'=> 'application/json', 'Accept' => 'application/json', 'X-WSSE' => auth }
    end

	end	
end
