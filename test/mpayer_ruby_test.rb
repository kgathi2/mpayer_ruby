require 'test_helper'

class TestMpayer < Minitest::Test
	def test_mpayer_setup
		# Setup defined in test_helper
		Mpayer.setup do |config|
			config.user_no = 'GLOBAL_USER'
			config.token = 'GLOBAL_TOKEN'
		end
		client = Mpayer::Client.new
		assert_equal(Mpayer.configuration.user_no, 'GLOBAL_USER')
		assert_equal(Mpayer.configuration.token, 'GLOBAL_TOKEN')
		assert_equal(client.config.user_no, 'GLOBAL_USER')
		assert_equal(client.config.token, 'GLOBAL_TOKEN')
	end

	def test_login
		credentials = Mpayer.login
		assert(credentials.token, "Failure message.")
	end
end