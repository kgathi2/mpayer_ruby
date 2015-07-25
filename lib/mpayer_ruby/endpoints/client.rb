module Mpayer
	class Client < Mpayer::Endpoint
		attr_writer :accounts, :account, :payables, :transactions

		class << self

			# Mpayer::Client.all
			def all(page:1,per_page:100)
			  url = "/clients/all_clients"
				Mpayer::Fetch.get(url,query:{page:page,per_page:per_page})
			end

			# Mpayer::Client.find(id)
			def find(client_id,fetch: true)
				url = "/clients/#{client_id}"
				response = Mpayer::Fetch.get(url) if fetch
				client = new(id:client_id,response:response)
			end

			# client_attributes = {client: { client_name: "Kiki Lolo", client_birthday: Time.now.iso8601, client_type: "ext", ac_type: "cu",client_mobile: '073373932', client_email: 'lolo@kiki.com',currency: "kes", mandate:"s", sub_type: "od" }}
			# Mpayer::Client.create(client_attributes)
			def create(options={})
				url = "/clients"
				# bp
				response = Mpayer::Fetch.post(url,options)
				client = new(options.merge!(id:response.id ,response:response, account: response.account.first)) rescue response
			end	

		end

		# Mpayer::Client.find(id:20284).account(accountsid)
		def account(account_id=nil,client_id=id)
			account_id ||= @account.id rescue nil
			raise "Arguments missing: account_id or client_id" if client_id.nil? or account_id.nil?
			url = "/clients/#{client_id}/accounts/#{account_id}"
			if (@account.id == account_id rescue false)
				@account ||= Mpayer::Fetch.get(url)
			else	
				@account = Mpayer::Fetch.get(url)
			end
		end
		
    # options = {account:{name: name, ac_type: ac_type, mandate: mandate, tags_attributes:@tags, infos_attributes:@infos}}
		# Mpayer::Client.find(id:20284).create_account(options)
		def create_account(options={})
      url = "/clients/#{self.id}/accounts/new"
			@account = Mpayer::Fetch.post(url,options)
		end

		# Mpayer::Client.find(26, fetch:false).accounts(page:1,per_page:100)
		def accounts(page:1,per_page:100)
			find_all(page:page,per_page:per_page)
		end

		# Mpayer::Client.find(26, fetch:false).payables(page:1,per_page:100)
		def payables(page:1,per_page:100)
			find_all(page:page,per_page:per_page)
		end

		# Mpayer::Client.find(26, fetch:false).transactions(account_id, page:1,per_page:100)
		def transactions(account_id,page:1,per_page:100)
			find_all(page:page,per_page:per_page,account_id:account_id)
		end

    protected

		def after_initialize
	    @endpoint = 'clients'
		end
    

	end	
end