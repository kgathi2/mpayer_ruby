require 'test_helper'

class TestMpayerAccount < Minitest::Test
	def setup
		account = nil
		super
	end

	def test_account_find_and_all
		# skip
		accounts = Mpayer::Account.all
		assert(accounts.is_a? Array)
		account_one = accounts.first
		account = Mpayer::Account.find(account_one.id)
		assert(account.is_a? Mpayer::Account)
	end

	def test_update_account
		# skip
		account = Mpayer::Account.find(25735)
		new_name = account.name.next
		account.update(name:new_name)
		assert_equal(new_name, account.name)
	end

	def test_account_aggregates
		# skip
		options = {
			from_date: Time.now -  (86400*365),
			to_date:nil, 
			dr_cr:nil, 
			ac_type:nil, 
			category:nil
		}
		accounts = Mpayer::Account.aggregates(options)
		assert(accounts.is_a? Array)
	end

	def test_get_client_members
		# skip 
		members = Mpayer::Account.find(25735, fetch:false).members
		assert(members.is_a?(Array), "Failure message.")
	end

	def test_get_client_payable_items
		# skip 
		payable_items = Mpayer::Account.find(25735, fetch:false).payable_items
		assert(payable_items.is_a?(Array), "Failure message.")
	end
end