module Mpayer
	class Account < Mpayer::Endpoint
		attr_writer :members, :payable_items
		
		class << self

			# Mpayer::Account.all()
			def all(page:1,per_page:100)
				url = "/accounts/all_accounts"
				Mpayer::Fetch.get(url,query:{page:page,per_page:per_page})
			end

			# options = {from_date:nil,to_date:nil, dr_cr:nil, ac_type:nil, category:nil}
			# Mpayer::Account.aggregate(options)
			def aggregates(page:1,per_page:100, **options)
				url = "/accounts/aggregates"
				Mpayer::Fetch.get(url,query:{page:page,per_page:per_page}.merge!(options))
			end

			# Mpayer::Account.find(account_id)
			def find(account_id,fetch:true)
				url = "/accounts/#{account_id}"
				response = Mpayer::Fetch.get(url) if fetch
				account = new(id:account_id,response:response)
			end

		end
		
		# account.update(name:new_name)
		def update(options)
			url = "/accounts/#{self.id}"
			response = Mpayer::Fetch.put(url,options)
			self.response = response
		end

		def enroll
			
		end

		# Mpayer::Account.find(26, fetch:false).members(page:1,per_page:100)
		def members(page:1,per_page:100)
			find_all(page:page,per_page:per_page)
		end

		# Mpayer::Account.find(26, fetch:false).payable_items(page:1,per_page:100)
		def payable_items(page:1,per_page:100)
			find_all(page:page,per_page:per_page)
		end

		protected

		def after_initialize
	    @endpoint = 'accounts'
		end

	end
end