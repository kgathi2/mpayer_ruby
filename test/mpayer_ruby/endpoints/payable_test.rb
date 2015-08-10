#     namespace 'payables' do
#       get '/' , :action=>:index
#       get '/all' , :action=>:all
#       get '/:id' , :action=>:show
#       get '/search/:ref_id',:action=>:search
#       delete '/:id' , :action => :destroy
#       post '/' , :action => :create
#       post '/update_flags' , :action => :bulk_update_flags
#       # post 'add_to/:id' , :action => :add_payable_item
#       # delete 'remove/:id/item/:item_id' , :action=>:remove_payable_item
#       # put '/:id' , :action => :update
#     end

require 'test_helper'

class TestMpayerPayable < Minitest::Test

	def test_payable_find_and_all
		# skip
		payables = Mpayer::Payable.all
		assert(payables.is_a? Array)
		payable_one = payables.first
		payable = Mpayer::Payable.find(payable_one.id)
		assert(payable.is_a? Mpayer::Payable)
	end

	def test_search_payable
		# skip
		search_ref = create_mpayer_payable.ref_id
		payable = Mpayer::Payable.where(ref_id:search_ref)
		refute_nil(payable, "Failure message.")
		assert(payable.is_a?(Mpayer::Payable), "Failure message.")
		payable = Mpayer::Payable.where(ref_id:"Ksdfsfsdf000411")
		assert_equal({"data"=>"not found"}, JSON.parse(payable))
	end

	def test_create_mpayer_payable
		# skip
		payable = create_mpayer_payable
		refute_nil(payable.id, "Failure message.#{payable.response}")
	end

	def test_destroy_payable
		# skip
		payable = create_mpayer_payable
		payable.destroy
		assert_equal(payable.id, nil)
		assert_equal(payable.attributes, nil)
		@@create_mpayer_payable = nil
		@@search_payable = nil
	end

end