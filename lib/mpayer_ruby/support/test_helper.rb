module Mpayer::TestHelper
	# login
	# create_mpayer_client
	# create_mpayer_account
	# create_mpayer_payable
	# get_mpayer_accounts
	# get_mpayer_account
	# create_mpayer_transaction
	# get_mpayer_transactions
	
	def mpayer_login
		@@mpayer_login ||= Mpayer.login
	end

	def create_mpayer_client
		client_attributes = {
			client: { 
				client_name: Faker::Name.name, 
				client_birthday: Time.now.iso8601, 
				client_type: "ext", 
				ac_type: "cu",
				client_mobile: Faker::Number.number(10) , 
				client_email: Faker::Internet.email,
				currency: "kes", 
				mandate:"s", 
				sub_type: "od" 
			}
		}
		@@create_mpayer_client ||= Mpayer::Client.create(client_attributes)
		@@client_account ||= Mpayer::Client.find(@@create_mpayer_client.id,fetch:false).account(@@create_mpayer_client.account.id)
		@@create_mpayer_client
	end

	def create_mpayer_account
		client = create_mpayer_client
		account_options = {
			account:{
				name: "#{client.fname} #{client.lname}", 
				ac_type: 'cu', 
				sub_type: 'od', 
				mandate: 's', 
				aliases_attributes: [{org_id:mpayer_login.org_no ,alias_key:'telephone', alias_value:"#{client.fname}#{SecureRandom.uuid.gsub('-','')}"}]
				# tags_attributes:@tags, 
				# infos_attributes:@infos
			}
		}
		@@create_mpayer_account ||= client.create_account(account_options)
		@@account ||= Mpayer::Client.find(client.id,fetch:false).account(@@create_mpayer_account.id)
		@@create_mpayer_account 
	end

	def create_mpayer_payable
		account = create_mpayer_account
		payable_items = []
		[*0..5].each do |n|
			payable_items << {
				payment_party: account.acid ,
				terminal_ac: account.acid ,
				details: Faker::Lorem.sentence ,
				amount: 10,
				price: 10,
				unit_measure: 1.0
			}
		end

    options = {
    	payment: {
    		payable_no: SecureRandom.uuid, 
    		note: Faker::Lorem.sentence ,
    		ref_id: SecureRandom.uuid,
    		# client_id: client_id, 
    		# status: @model.status,
    		# payable_type: @model.payable_type,
    		due_date: Time.now+(86400*31), 
    		pay: payable_items
    		# tags:@tags,
    		# flags:@flags,
    		# infos:@infos ,
    		# sync_lag:@sync_lag
    		}
    	}
    @@create_mpayer_payable ||= Mpayer::Payable.create(options)
		@@search_payable ||= Mpayer::Payable.where(ref_id:@@create_mpayer_payable.ref_id)
    @@create_mpayer_payable
	end

	def get_mpayer_accounts
		@@get_mpayer_accounts ||= Mpayer::Account.all
	end

	def get_mpayer_account
		first_account = get_mpayer_accounts.first
		@@get_mpayer_account ||= Mpayer::Account.find(first_account.id)
	end

	def create_mpayer_transaction
		body = {particulars:Faker::Lorem.sentence,amount:1000, cr_party: get_mpayer_account.acid}
    body.merge!({ref_num:Faker::Code.isbn})
    @@create_mpayer_transaction ||= Mpayer::Transaction.deposit(body)
    @@search_tran ||= Mpayer::Transaction.where(ref_id:@@create_mpayer_transaction.ref_id)
		@@create_mpayer_transaction
	end

	def get_mpayer_transactions
		@@get_mpayer_transactions ||= Mpayer::Transaction.all(from: Time.now -  (86400*400))
		@@get_mpayer_transactions.any? ? @@get_mpayer_transactions : [create_mpayer_transaction]
	end
end