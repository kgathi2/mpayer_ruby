#     namespace 'messages' do
#       post '/' , :action => :create
#     end

require 'test_helper'

class TestMpayerMessage < Minitest::Test
	def test_create_message
		skip
		message_attributes = {message: 'Please send me a message', destination:'0722002200,254720002200'}
		message = Mpayer::Message.create(message_attributes)
		refute_nil(message.id, "Failure message.")
	end
end