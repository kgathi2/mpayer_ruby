#     namespace 'accounts' do
#       get '/', :action=>:index
#       get 'all_accounts' ,:action=>:all_accounts
#       get 'aggregates' ,:action=>:aggregates
#       get ':id', :action=>:show
#       put ':id' ,:action=>:update
#       get ':id/payable_items' ,:action => :payable_items
#       post ':id/enroll' ,:action=>:enroll
#       get ':id/members' ,:action=>:account_holders
#     end

require 'test_helper'

class TestMpayerAccount < Minitest::Test

	def test_account_find_and_all
		# skip
		accounts = get_mpayer_accounts
		assert(accounts.is_a? Array)
		account = get_mpayer_account
		assert(account.is_a? Mpayer::Account)
	end

	def test_update_account
		# skip
		account = get_mpayer_account
		new_name = account.name.next
		updated_account = account.update(name:new_name)
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
		members = get_mpayer_account.members
		assert(members.is_a?(Array), "Failure message.")
	end

	def test_get_client_payable_items
		# skip 
		payable_items = get_mpayer_account.payable_items
		assert(payable_items.is_a?(Array), "Failure message.")
	end
end