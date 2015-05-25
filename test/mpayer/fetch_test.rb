require 'test_helper'

class TestMpayerFetch < Minitest::Test
  def test_proper_request_formating
  	# assert_equal(["Content-Type", "Accept", "X-WSSE"],Mpayer::Fetch.default_options.keys, "Failure message.")
  	# r = Mpayer::Fetch.default_options
  	# r = Mpayer::Fetch.get("/api/json/get/AnFEUnG")
  	# binding.pry
  end

  def test_unauthorised
  	Mpayer.setup do |config|
			config.user_no = 'GLOBAL_USER'
			config.token = 'GLOBAL_TOKEN'
		end
		request = Mpayer::Client.all
		assert(request.base, "Failure message.")
		assert_equal(["Authentication Failed"], request.base)
  end
end