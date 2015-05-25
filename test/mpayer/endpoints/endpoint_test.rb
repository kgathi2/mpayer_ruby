require 'test_helper'

class TestMpayerEndPoint < Minitest::Test
	def test_find_all
		
	end

	def test_set_config
		
	end

	def test_initializer
		
	end

	def test_missing_methods
		
	end

	def test_client_assoc_link
		client = Mpayer::Client.find(26, fetch:false)
		transaction_link = client.send(:assoc_link,:transactions,account_id:12)
		assert_equal("/clients/26/accounts/12/transactions", transaction_link)
		accounts_link = client.send(:assoc_link,:accounts)
		assert_equal("/clients/26/accounts", accounts_link)
		payables_link = client.send(:assoc_link,:payables)
		assert_equal( "/clients/26/payables", payables_link)
	end
end