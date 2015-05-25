require 'test_helper'

class TestMpayerConfiguration < Minitest::Test

	def test_default_value_of_configurations
		assert_equal(Mpayer::Configuration.new.user_no, nil)
		assert_equal(Mpayer::Configuration.new.token, nil)
		refute_nil(Mpayer.configuration.auth, "Failure message.")
		refute_nil(Mpayer.configuration.header, "Failure message.")
	end

	def test_initializer
		config = Mpayer::Configuration.new(user_no:'KIKI',token:'LOLO')
		assert_equal('KIKI',config.user_no, "Failure message.")
		assert_equal('LOLO',config.token, "Failure message.")
	end

	def test_client_local_vs_global_configs
		Mpayer.setup do |config|
			config.user_no = 'GLOBAL_USER'
			config.token = 'GLOBAL_TOKEN'
		end
		client = Mpayer::Client.new
		assert_equal(Mpayer.configuration.user_no, 'GLOBAL_USER')
		assert_equal(Mpayer.configuration.token, 'GLOBAL_TOKEN')
		assert_equal(client.config.user_no, 'GLOBAL_USER')
		assert_equal(client.config.token, 'GLOBAL_TOKEN')
		
		# config = Hashie::Mash.new(user_no:'LOCAL_USER1', token:'LOCAL_TOKEN1')
		config = {user_no:'LOCAL_USER1', token:'LOCAL_TOKEN1'}
		client = Mpayer::Client.new(config:config)
		assert_equal(Mpayer.configuration.user_no, 'GLOBAL_USER')
		assert_equal(Mpayer.configuration.token, 'GLOBAL_TOKEN')
		assert_equal(client.config.user_no, 'LOCAL_USER1')
		assert_equal(client.config.token, 'LOCAL_TOKEN1')
		refute_nil(client.config.auth, "Failure message.")
		refute_nil(client.config.header, "Failure message.")
		refute_equal(client.config.auth, Mpayer.configuration.auth)

		client = Mpayer::Client.new
		client.config.user_no = "LOCAL_USER2"
		client.config.token = "LOCAL_TOKEN2"
		assert_equal(Mpayer.configuration.user_no, 'GLOBAL_USER')
		assert_equal(Mpayer.configuration.token, 'GLOBAL_TOKEN')
		assert_equal(client.config.user_no, 'LOCAL_USER2')
		assert_equal(client.config.token, 'LOCAL_TOKEN2')
	end

end