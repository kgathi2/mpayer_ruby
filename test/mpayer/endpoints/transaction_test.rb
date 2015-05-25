require 'test_helper'

class TestMpayerTransaction < Minitest::Test

	def setup
		transactions = nil
		super
	end

	def test_get_all_transactions
		skip
		transactions = Mpayer::Transaction.all(from: Time.now -  (86400*400))
		assert(transactions.is_a?(Array), "Failure message.")
	end

	def test_search_transactions
		skip
		transaction = Mpayer::Transaction.where(ref_id:"KT0041[P]-010000402")
		refute_nil(transaction, "Failure message.")
		assert(transaction.is_a?(Mpayer::Transaction), "Failure message.")
	end

	def test_deposit
		skip
    body = {particulars:"particulars",amount:1000, cr_party: "pz_test"}
    body.merge!({ref_num:'254720215569'})
		deposit = Mpayer::Transaction.deposit(body)
		assert(deposit.is_a?(Mpayer::Transaction), "Failure message.")
		refute_nil(deposit.id, "Failure message.")
	end

	def test_withdraw
		skip
		body = {particulars:"particulars",amount:10, dr_party: "pz_test"}
		withdrawal = Mpayer::Transaction.withdraw(body)
		assert(withdrawal.is_a?(Mpayer::Transaction), "Failure message.")
		refute_nil(withdrawal.id, "Failure message.")
	end

	def test_transfer
		skip
		body = {particulars:"particulars",amount:10, cr_party: "pz_test2", dr_party:"pz_test" }
		transfer = Mpayer::Transaction.transfer(body)
		assert(transfer.is_a?(Mpayer::Transaction), "Failure message.")
		refute_nil(transfer.id, "Failure message.")
	end

	def test_mpayer_ref
		refs = Mpayer::Transaction.mpayer_refs
		assert(refs.has_key?(:ref_id), "Failure message.")
	end
	
end