module Mpayer
	class Payable < Mpayer::Endpoint
		# attr_writer :accounts, :account, :payables, :transactions
		
		class << self
			def all(per:1,per_page:100)
				
			end

			def find(id,fetch:true)
				
			end

			def create(options={})
				
			end
		end

		# ###### the association methods
		# # Mpayer::Client.find(26, fetch:false).association(per:1,per_page:100)
		# def association(per:1,per_page:100)
		# 	find_all(per:per,per_page:per_page)
		# end

		protected

		def after_initialize
	    @endpoint = 'payables'
		end

	end
end