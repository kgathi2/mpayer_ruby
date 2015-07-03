require 'test_helper'

class TestMpayerEndPoint < Minitest::Test
	def test_find_all
		
	end

	def test_set_config
		
	end

	def test_initializer
		
	end

	def test_id_cant_be_initialised_with_nil
		assert_raises(Exception) { Mpayer::Endpoint.new(id:nil) }
		assert_raises(Exception) { Mpayer::Endpoint.new.id=nil }
		assert_raises(Exception) { Mpayer::Client.find(nil, fetch:false) }
	end

	def test_delete_object
		endpoint = Mpayer::Endpoint.new(id:1)
		assert(endpoint, "Failure message.")
		endpoint.send(:kill)
		assert_equal(endpoint.id, nil)
		assert(endpoint.frozen?, 'Object has need deleted')
	end

	def test_missing_methods
		client = Mpayer::Client.find(23,fetch:false)
		client.response = Hashie::Mash.new({email:'kiki@lolo.com', name:'Kiki Lolo'})
		assert_equal('kiki@lolo.com', client.email)
		assert_equal('Kiki Lolo', client.name)
		client.response.email = nil
		assert_equal(nil, client.email)
		assert_raises(NoMethodError) { client.badmethods }
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

	def test_success?
		client = Mpayer::Client.new
		refute(client.success?, "Failure message.")
		client = create_mpayer_client
		assert(client.success?, "Failure message.")
	end
end