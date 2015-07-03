$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'mpayer_ruby'
require 'mpayer_ruby/support/test_helper'
require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters' # requires the gem
require 'pry'
require "pry-alias"
require 'faker'

# ENV['LOAD_MPAYER'] = "true"

if ENV['CI_TEST'].nil? and ENV['LOAD_MPAYER'] != "true"
	require 'webmock/minitest' 
	WebMock.disable_net_connect!(allow_localhost: true) #,:allow => "app.mpayer.co.ke")
	require 'mpayer_ruby/support/fake_mpayer' 
else
	File.delete(*Dir.glob('lib/mpayer_ruby/support/**/*.json'))
end

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new # spec-like progress

class Minitest::Test
	include Mpayer::TestHelper

	def setup
		Mpayer.setup do |config|
			# Setup test with Mpayer Demo account. 
			# config.base_url = ENV['MPAYER_URL']
			config.user_no = ENV['MPAYER_USER']
			config.token = ENV['MPAYER_TOKEN']
		end
		# https://robots.thoughtbot.com/how-to-stub-external-services-in-tests
    stub_request(:any, /app.mpayer.co.ke/).to_rack(FakeMpayer) if ENV['CI_TEST'].nil? and ENV['LOAD_MPAYER'] != "true"
    # Not Authorized
    # stub_request(:get, "https://app.mpayer.co.ke/api/clients/12345").
    # with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'X-Wsse'=>''}).
    # to_return(:status => 200, :body => {base:["Authentication Failed"]}.to_json, :headers => {})
    # mpayer_login
    # create_mpayer_client
    # create_mpayer_account
    # create_mpayer_payable
    # get_mpayer_accounts
    # get_mpayer_account
    # create_mpayer_transaction
    # get_mpayer_transactions
	end

end