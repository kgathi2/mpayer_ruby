require 'test_helper'

class TestMpayerFetch < Minitest::Test
  def test_unauthorised
    # skip
    url = "/clients/12345"
    request = Mpayer::Fetch.get(url,headers:{"X-WSSE"=>""})
		assert(request.base, "Failure message.")
		assert_equal(["Authentication Failed"], request.base)
		
		url = "/clients/12345"
    request = Mpayer::Fetch.get(url,headers:{})
		assert(request.base, "Failure message.")
		assert_equal(["Authentication Failed"], request.base)
  end
end