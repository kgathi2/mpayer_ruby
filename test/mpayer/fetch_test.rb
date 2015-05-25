require 'test_helper'

class TestMpayerFetch < Minitest::Test
  def test_unauthorised
    skip
  	Mpayer.setup do |config|
			config.user_no = 'GLOBAL_USER'
			config.token = 'GLOBAL_TOKEN'
		end
    url = "/clients/all_clients"
    request = Mpayer::Fetch.get(url)
		assert(request.base, "Failure message.")
		assert_equal(["Authentication Failed"], request.base)
  end
end