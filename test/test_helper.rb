$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'mpayer_ruby'
require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters' # requires the gem
require 'pry'
require "pry-alias"



if ENV['CI_TEST'].nil? and ENV['LOAD_MPAYER'] != "true"
	require 'webmock/minitest' 
	WebMock.disable_net_connect!(allow_localhost: true) #,:allow => "app.mpayer.co.ke")
	require 'mpayer_ruby/support/fake_mpayer' 
end

# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new # spec-like progress

class Minitest::Test

	def setup
		Mpayer.setup do |config|
			# Setup test with Mpayer Demo account. 
			config.user_no = ENV['MPAYER_USER']
			config.token = ENV['MPAYER_TOKEN']
		end
		# https://robots.thoughtbot.com/how-to-stub-external-services-in-tests
    stub_request(:any, /app.mpayer.co.ke/).to_rack(FakeMpayer) if ENV['CI_TEST'].nil? and ENV['LOAD_MPAYER'] != "true"
	end
end