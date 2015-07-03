module Mpayer
	class Payable < Mpayer::Endpoint
		
		class << self

			# Mpayer::Payable.all
			def all(page:1,per_page:100)
				url = "/payables/all"
				Mpayer::Fetch.get(url,query:{page:page,per_page:per_page})
			end

			# Mpayer::Payable.find(id)
			def find(payable_id,fetch:true)
				url = "/payables/#{payable_id}"
				response = Mpayer::Fetch.get(url) if fetch
				payable = new(id:payable_id,response:response)
			end

			# Mpayer::Payable.where(ref_id:"KT0041[P]-010000402")
			def where(ref_id:,fetch:true)
				url = "/payables/search/#{CGI.escape(ref_id.to_s)}"
				response = Mpayer::Fetch.get(url) if fetch
				payable = new(id:response.id,response:response) unless (response.id rescue nil).nil?
			end

			# Mpayer::Payable.create(options)
			def create(options={})
				url = "/payables"
				response = Mpayer::Fetch.post(url,options)
				payable_id = response.id 
				payable = new(options.merge!(id:payable_id,response:response))
			end
		end

		def destroy
			url = "/payables/#{self.id}"
			self.response = Mpayer::Fetch.delete(url)
			self.kill
		end

		protected

		def after_initialize
	    @endpoint = 'payables'
		end

	end
end