# namespace 'api' do
#   get '/' , :action=>:index ,:controller=> :transactions
#   post '/login' ,:action=>:login , :controller => :authorized_api
#   post '/credentials' ,:action=>:credentials , :controller => :authorized_api
#   constraints(:id => /\d+/, :format=>/(json)|(xml)/) do
#   end
# end

require 'test_helper'

class TestMpayerFetch < Minitest::Test
  def test_unauthorised
    # skip
  	Mpayer.setup do |config|
			config.user_no = nil
			config.token = nil
		end

    url = "/clients/12345"
    request = Mpayer::Fetch.get(url)
		assert_equal(["Authentication Failed"], request.base)
  end
end



