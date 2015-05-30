#     namespace 'transactions' do
#       get '/' , :action=>:index
#       get '/all' ,:action=>:all_transactions
#       get ':ref_id' , :action=>:show_by_ref
#       # put 'deposit' ,:action=>'deposit' ,:format=>'xml'
#       put :deposit ,:action=> :deposit # ,:format=>'json'
#       delete :withdraw ,:action=> :withdraw
#       post :transfer ,:action=> :transfer
#     end

require 'test_helper'

class TestMpayerTransaction < Minitest::Test

	def setup
		transactions = nil
		super
	end

	# def get_transactions
	# 	@transactions ||= Mpayer::Transaction.all(from: Time.now -  (86400*400))
	# 	@transactions.any? ? @transactions : [create_transaction]
	# end

	# def create_transaction
	# 	body = {particulars:Faker::Lorem.sentence,amount:1000, cr_party: create_account.acid}
 #    body.merge!({ref_num:Faker::Code.isbn})
	# 	Mpayer::Transaction.deposit(body)
	# end

	def test_get_all_transactions
		# skip
		transactions = get_transactions
		assert(transactions.is_a?(Array), "Failure message.")
	end

	def test_search_transactions
		# skip
		search_ref = create_transaction.ref_id
		transaction = Mpayer::Transaction.where(ref_id:search_ref)
		refute_nil(transaction, "Failure message.")
		assert(transaction.is_a?(Mpayer::Transaction), "Failure message.")
	end

	def test_deposit
		# skip
		deposit = create_transaction
		assert(deposit.is_a?(Mpayer::Transaction), "Failure message.")
		refute_nil(deposit.id, "Failure message. #{deposit.response.body}")
	end

	def test_withdraw
		# skip
		body = {particulars:Faker::Lorem.sentence,amount:10, dr_party: create_account.acid}
		withdrawal = Mpayer::Transaction.withdraw(body)
		assert(withdrawal.is_a?(Mpayer::Transaction), "Failure message.")
		refute_nil(withdrawal.id, "Failure message.#{withdrawal.response.body}")
	end

	def test_transfer
		# skip
		body = {particulars:Faker::Lorem.sentence,amount:10, cr_party: create_account.acid, dr_party:create_account.acid }
		transfer = Mpayer::Transaction.transfer(body)
		assert(transfer.is_a?(Mpayer::Transaction), "Failure message.")
		refute_nil(transfer.id, "Failure message.#{transfer.response.body}")
	end

	def test_mpayer_ref
		# skip
		refs = Mpayer::Transaction.mpayer_refs
		assert(refs.has_key?(:ref_id), "Failure message.")
	end

	def test_transactions_with_alias
		# skip
		body = {particulars:Faker::Lorem.sentence,amount:1000, cr_party: create_account.aliases.first.alias_value}
		deposit = Mpayer::Transaction.deposit(body)
		assert(deposit.is_a?(Mpayer::Transaction), "Failure message.")
		refute_nil(deposit.id, "Failure message.#{deposit.response.body}")
	end
	
end