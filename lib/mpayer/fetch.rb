module Mpayer
	class Fetch
		include HTTParty
		# base_uri "http://beta.json-generator.com"
		base_uri "https://app.mpayer.co.ke/api/"
    parser proc {|data| Hashie::Mash.new(response:JSON.parse(data)).response}
    format :json
    headers 

		class << self
			def headers
				Mpayer.configuration.header.merge!(super)
			end
		end

	end
end