#     namespace 'clients' do
#       get '/', :action=>:index
#       get 'all_clients' ,:action=>:all_clients
#       get ':id', :action=>:show
#       put ':id', :action=>:update
#       get ':id/accounts' , :action=>:accounts
#       post ':id/accounts/new' , :action=>:create_account
#       get ':id/accounts/:account_id' , :action=>:show_account
#       get ':id/accounts/:account_id/transactions' , :action=>:transactions
#       get ':id/accounts/:account_id/transactions/:tran_id' , :action=>:show_transaction
#       get ':id/accounts/:account_id/transaction_sets' , :action=>:transaction_sets
#       post '/' , :action=> :create_client
#       get ':id/payables' ,:action => :payables
#       get ':id/payable_items' ,:action => :payable_items
#       get ':id/payables/:payable_id' ,:action => :show_payable
#     end

require 'test_helper'

class TestMpayerClient < Minitest::Test

	def test_client_find_and_all
		# skip
		clients = Mpayer::Client.all
		assert(clients.is_a? Array)
		client_one = clients.first
		client = Mpayer::Client.find(client_one.id)
		assert(client.is_a? Mpayer::Client)
	end

	def test_create_client
		# skip skip
		client = create_client
		refute_nil(client.id, "Failure message.")
	end

	def test_get_client_account
		# skip
		client = create_client
		accounts = client.accounts(page:1,per_page:100)
		account = client.account(accounts.last.id)
		assert(account.is_a?(Hash), "Failure message.")
	end

	def test_create_new_account
		# skip
		account = create_account
		refute_nil(account, "Failure message.")
	end

	def test_get_client_accounts_and_transactions
		# skip
		accounts = create_client.accounts
		assert(accounts.is_a?(Array), "Failure message.")

		account_id = accounts.last.id
		transactions = create_client.transactions(account_id)
		assert(transactions.is_a?(Array), "Failure message.")
	end

	def test_get_client_payables
		# skip
		accounts = create_client.payables
		assert(accounts.is_a?(Array), "Failure message.")
	end

end