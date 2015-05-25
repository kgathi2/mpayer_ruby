$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mpayer'

require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
# require 'minitest/reporters' # requires the gem
require 'pry'

# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new # spec-like progress

class Minitest::Test
	def setup
		Mpayer.setup do |config|
			# Setup test with Mpayer Demo account. 
			config.user_no = ENV['MPAYER_USER']
			config.token = ENV['MPAYER_TOKEN']
		end
	end
end