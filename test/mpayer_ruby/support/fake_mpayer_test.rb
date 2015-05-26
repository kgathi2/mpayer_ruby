require 'rubygems'
require 'pry'
require "pry-alias"
require 'mpayer_ruby'

Mpayer.setup do |config|
	config.user_no = ENV['MPAYER_USER']
	config.token = ENV['MPAYER_TOKEN']
end

def save_json(response)
	request_method = response.request.http_method.name.split('::').last.upcase
	file_path = response.request.path.to_s
	slash,model,*file_name = file_path.split('/')
	file_location = "test/support/fake_mpayer/#{model}/#{request_method}_#{file_name.join('_')}.json"
	File.write(file_location, response.body)
end
