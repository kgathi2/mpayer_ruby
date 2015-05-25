require 'test_helper'

class TestMpayerClient < Minitest::Test

	def setup
		client = nil
		account = nil
		super
	end

	def test_client_find_and_all
		# skip
		clients = Mpayer::Client.all
		assert(clients.is_a? Array)
		client_one = clients.first
		client = Mpayer::Client.find(client_one.id)
		assert(client.is_a? Mpayer::Client)
	end

	def test_create_client
		skip skip
		client_attributes = {
			client: { 
				client_name: "Kiki Lolo", 
				client_birthday: Time.now.iso8601, 
				client_type: "ext", 
				ac_type: "cu",
				client_mobile: '073373932', 
				client_email: 'lolo@kiki.com',
				currency: "kes", 
				mandate:"s", 
				sub_type: "od" 
			}
		}
		client = Mpayer::Client.create(client_attributes)
		refute_nil(client.id, "Failure message.")
	end

	def test_get_client_account
		# skip
		client = Mpayer::Client.find(26, fetch:false)
		accounts = client.accounts(per:1,per_page:100)
		account = client.account(accounts.first.id)
		assert(account.is_a?(Hash), "Failure message.")
	end

	def test_create_new_account
		skip skip
		client = Mpayer::Client.find(26, fetch:false)
		account_options = {
			account:{
				name: 'PZ alias Account', 
				ac_type: 'cu', 
				mandate: 's', 
				aliases_attributes: [{org_id:2 ,alias_key:'telephone', alias_value:'pz_test3'}]
				# tags_attributes:@tags, 
				# infos_attributes:@infos
				}
			}
		# binding.pry
		account = client.create_account(account_options)
		refute_nil(account, "Failure message.")
		assert_equal(account, client.account)
	end

	def test_get_client_accounts
		# skip
		accounts = Mpayer::Client.find(26, fetch:false).accounts
		assert(accounts.is_a?(Array), "Failure message.")
	end

	def test_get_client_payables
		# skip
		accounts = Mpayer::Client.find(26, fetch:false).payables
		assert(accounts.is_a?(Array), "Failure message.")
	end

	def test_get_client_account_transactions
		# skip
		account_id = 87 # account = client.accounts.last.id
		transactions = Mpayer::Client.find(26, fetch:false).transactions(account_id)
		assert(transactions.is_a?(Array), "Failure message.")
	end

end