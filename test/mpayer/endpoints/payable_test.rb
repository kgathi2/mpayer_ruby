require 'test_helper'

class TestMpayerPayable < Minitest::Test
	def setup
		payable = nil
		super
	end

	def test_payable_find_and_all
		skip
		payables = Mpayer::Payable.all
		assert(payables.is_a? Array)
		payable_one = payables.first
		payable = Mpayer::Payable.find(payable_one.id)
		assert(payable.is_a? Mpayer::Payable)
	end

	def test_search_payable
		skip
		payable = Mpayer::Payable.where(ref_id:"KT0041-010000411")
		refute_nil(payable, "Failure message.")
		assert(payable.is_a?(Mpayer::Payable), "Failure message.")
		payable = Mpayer::Payable.where(ref_id:"Ksdfsfsdf000411")
		assert_nil(payable, "Failure message.")
		assert(payable.is_a?(Mpayer::Payable), "Failure message.")
	end

	def test_create_payable
		skip
		payable_items = []
		[*0..5].each do |n|
			payable_items << {
				payment_party: 'pz_test' ,
				terminal_ac: 'pz_test2' ,
				details: "paying to test account" ,
				amount: 10,
				price: 10,
				unit_measure: 1.0
			}
		end

    options = {
    	payment: {
    		payable_no: rand(10000), 
    		note: "payable to pay something",
    		ref_id:rand(10000),
    		# client_id: client_id, 
    		# status: @model.status,
    		# payable_type: @model.payable_type,
    		due_date: Time.now+(86400*31), 
    		pay: payable_items
    		# tags:@tags,
    		# flags:@flags,
    		# infos:@infos ,
    		# sync_lag:@sync_lag
    		}
    	}
    payable = Mpayer::Payable.create(options)
		refute_nil(payable.id, "Failure message.")
	end

	def test_delete_payable
		skip
		payable = Mpayer::Payable.find(8818,fetch:false)
		payable.destroy
	end

end