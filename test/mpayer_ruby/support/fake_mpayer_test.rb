require 'test_helper'

class TestMpayerFakeMpayer < Minitest::Test

	def setup
		Mpayer.setup do |config|
			config.user_no = ENV['MPAYER_USER']
			config.token = ENV['MPAYER_TOKEN']
		end
	end

	def save_json(response)
		request_method = response.request.http_method.name.split('::').last.upcase
		file_path = response.request.path.to_s
		slash,model,*file_name = file_path.split(/\/|\?/)
		file_location = "lib/mpayer_ruby/support/fake_mpayer/#{model}/#{request_method}_#{file_name.join('_')}.json"
		File.write(file_location, response.body)
	end

	def test_store_json
		
	end

end

# require 'rubygems'
# require 'pry'
# require "pry-alias"
# require 'mpayer_ruby'

# Mpayer.setup do |config|
# 	config.user_no = ENV['MPAYER_USER']
# 	config.token = ENV['MPAYER_TOKEN']
# end

# def save_json(response)
# 	request_method = response.request.http_method.name.split('::').last.upcase
# 	file_path = response.request.path.to_s
# 	slash,model,*file_name = file_path.split(/\/|\?/)
# 	file_location = "lib/mpayer_ruby/support/fake_mpayer/#{model}/#{request_method}_#{file_name.join('_')}.json"
# 	File.write(file_location, response.body)
# end

# message_attributes = {message: 'Please send me a message', destination:'0722684648,254720215569'}
# 		message = Mpayer::Message.create(message_attributes)