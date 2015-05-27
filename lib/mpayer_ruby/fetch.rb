module Mpayer
	class Fetch
		include HTTParty

		base_uri "https://app.mpayer.co.ke/api/"
    parser proc {|data| Hashie::Mash.new(response: (JSON.parse(data) rescue {data:data}.to_json)  ).response}
    format :json
    headers 

		class << self
			def headers
				Mpayer.configuration.header.merge!(super)
			end

			%w(get put post delete).each do |m|
				define_method m do |path, options={}, &block|
					res = perform_request Net::HTTP::Put, path, options, &block if m == 'put'
					res = perform_request Net::HTTP::Get, path, options, &block if m == 'get'
					res = perform_request Net::HTTP::Post, path, options, &block if m == 'post'
					res = perform_request Net::HTTP::Delete, path, options, &block if m == 'delete'
					save_json(res) if load_json?
					res
				end
			end

			def save_json(response)
				request_method = response.request.http_method.name.split('::').last.upcase
				file_path = response.request.path.to_s
				slash,model,*file_name = file_path.split(/\/|\?/)
				file_location = "lib/mpayer_ruby/support/fake_mpayer/#{model}/#{request_method}_#{file_name.join('_')}.json"
				File.write(file_location, response.body)
			end

			def load_json?
				# load JSON if WebMock is off while testing and only in local env with load mpayer turned on
				defined?(WebMock).nil? and ENV['CI_TEST'].nil? and defined?(Minitest) and ENV['LOAD_MPAYER'] == "true"
			end

		end

	end
end