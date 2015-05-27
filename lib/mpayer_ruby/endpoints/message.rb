module Mpayer
	class Message < Mpayer::Endpoint

		class << self
			# message_attributes = {message: 'Please send me a message', destination:'0722737343,343843843'}
			# Mpayer::Message.create(message_attributes)
			def create(options={})
				url = "/messages"
				response = Mpayer::Fetch.post(url,body: options.to_json)
				message = new(options.merge!(id:response.id ,response:response))
			end

		end

    protected

		def after_initialize
	    @endpoint = 'messages'
		end

	end	
end