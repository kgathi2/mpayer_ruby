module Mpayer
	class Transaction < Mpayer::Endpoint

		class << self

			# Mpayer::Transaction.all(from: Time.now -  (86400*400))
			def all(per:1,per_page:100,from: nil,to: nil)
				url = "/transactions/all"
				from = from.strftime("%F %T") unless from.nil?
				to = to.strftime("%F %T") unless to.nil? 
				Mpayer::Fetch.get(url,query:{per:per,per_page:per_page,from:from,to:to})
			end

			# Mpayer::Transaction.where(ref_id:"KT0041[P]-010000402")
			def where(ref_id:,fetch:true)
				url = "/transactions/#{CGI.escape(ref_id)}"
				response = Mpayer::Fetch.get(url) if fetch
				transaction = new(id:response.id,response:response)
			end

      # body = {particulars:particulars,ref_id:mpayer_ref_id,amount:amount, cr_party: cr_party}
			# Mpayer::Transaction.deposit(body)
			def deposit(**options)
				url = "/transactions/deposit"
				response = Mpayer::Fetch.put(url,body: mpayer_refs.merge!(options).to_json)
				transaction = new(id:response.id,response:response)
			end

      # body = {particulars:particulars,ref_id:mpayer_ref_id,amount:amount,dr_party: dr_party}
			# Mpayer::Transaction.withdraw(body)
			def withdraw(**options)
				url = "/transactions/withdraw"
				response = Mpayer::Fetch.delete(url,body: mpayer_refs.merge!(options).to_json)
				transaction = new(id:response.id,response:response)
			end

      # body = {particulars:particulars,ref_id:mpayer_ref_id,amount:amount,dr_party: dr_party, cr_party: cr_party}
			# Mpayer::Transaction.transfer(body)
			def transfer(**options)
				url = "/transactions/transfer"
				response = Mpayer::Fetch.post(url,body: mpayer_refs.merge!(options).to_json)
				transaction = new(id:response.id,response:response)
			end

			# Integrating app should get this from their db or just random unique
			def mpayer_refs
				{ref_id: SecureRandom.uuid}
			end
		end

		protected

		def after_initialize
			@endpoint = 'transactions'
		end

	end
end