module Mpayer
	class Configuration
		attr_accessor :user_no, :token, :base_url, :time_zone

    def initialize(user_no:nil,token:nil,time_zone:nil,base_url:'https://app.mpayer.co.ke/api/')
    	@base_url ||= base_url 
    	@user_no ||= user_no
    	@token ||= token
      @time_zone ||= time_zone
      set_time_zone
    end

    def time_zone=(value)
      set_time_zone(value)
      @time_zone = value
    end

    def auth
    	WSSE::header(user_no, token) unless user_no.nil? and token.nil?
    end

    def header
		  {'Content-Type'=> 'application/json', 'Accept' => 'application/json', 'X-WSSE' => auth.to_s}
    end

    private

    def set_time_zone(tz = nil)
      time_zone = tz || @time_zone || Time.zone || 'UTC'
      Time.zone = time_zone unless time_zone.nil?
    end

	end	
end
