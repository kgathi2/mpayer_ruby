$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!

require 'mpayer_ruby'
require 'minitest'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters' # requires the gem
require 'pry'
require "pry-alias"
require 'faker'


# ENV['LOAD_MPAYER'] = "true"

if ENV['CI_TEST'].nil? and ENV['LOAD_MPAYER'] != "true"
	require 'webmock/minitest' 
	WebMock.disable_net_connect!(allow_localhost: true) #,:allow => "app.mpayer.co.ke")
	require 'mpayer_ruby/support/fake_mpayer' 
else
	File.delete(*Dir.glob('lib/mpayer_ruby/support/**/*.json'))
end

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new # spec-like progress

class Minitest::Test

	def setup
		Mpayer.setup do |config|
			# Setup test with Mpayer Demo account. 
			# config.base_url = ENV['MPAYER_URL']
			config.user_no = ENV['MPAYER_USER']
			config.token = ENV['MPAYER_TOKEN']
		end
		# https://robots.thoughtbot.com/how-to-stub-external-services-in-tests
    stub_request(:any, /app.mpayer.co.ke/).to_rack(FakeMpayer) if ENV['CI_TEST'].nil? and ENV['LOAD_MPAYER'] != "true"
    # Not Authorized
    # stub_request(:get, "https://app.mpayer.co.ke/api/clients/12345").
    # with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json', 'X-Wsse'=>''}).
    # to_return(:status => 200, :body => {base:["Authentication Failed"]}.to_json, :headers => {})
    # login
    # create_client
    # create_account
    # create_payable
    # create_transaction
    # get_accounts
    # get_account
	end

	def login
		@@login ||= Mpayer.login
	end

	def create_client
		client_attributes = {
			client: { 
				client_name: Faker::Name.name, 
				client_birthday: Time.now.iso8601, 
				client_type: "ext", 
				ac_type: "cu",
				client_mobile: Faker::Number.number(10) , 
				client_email: Faker::Internet.email,
				currency: "kes", 
				mandate:"s", 
				sub_type: "od" 
			}
		}
		@@create_client ||= Mpayer::Client.create(client_attributes)
		@@client_account ||= Mpayer::Client.find(@@create_client.id,fetch:false).account(@@create_client.account.id)
		@@create_client
	end

	def create_account
		client = create_client
		account_options = {
			account:{
				name: "#{client.fname} #{client.lname}", 
				ac_type: 'cu', 
				sub_type: 'od', 
				mandate: 's', 
				aliases_attributes: [{org_id:login.org_no ,alias_key:'telephone', alias_value:"#{client.fname}#{SecureRandom.uuid.gsub('-','')}"}]
				# tags_attributes:@tags, 
				# infos_attributes:@infos
			}
		}
		@@create_account ||= client.create_account(account_options)
		@@account ||= Mpayer::Client.find(client.id,fetch:false).account(@@create_account.id)
		@@create_account 
	end

	def create_payable
		account = create_account
		payable_items = []
		[*0..5].each do |n|
			payable_items << {
				payment_party: account.acid ,
				terminal_ac: account.acid ,
				details: Faker::Lorem.sentence ,
				amount: 10,
				price: 10,
				unit_measure: 1.0
			}
		end

    options = {
    	payment: {
    		payable_no: SecureRandom.uuid, 
    		note: Faker::Lorem.sentence ,
    		ref_id: SecureRandom.uuid,
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
    @@create_payable ||= Mpayer::Payable.create(options)
		@@search_payable ||= Mpayer::Payable.where(ref_id:@@create_payable.ref_id)
    @@create_payable
	end

	def get_accounts
		@@get_accounts ||= Mpayer::Account.all
	end

	def get_account
		first_account = get_accounts.first
		@@get_account ||= Mpayer::Account.find(first_account.id)
	end

	def create_transaction
		body = {particulars:Faker::Lorem.sentence,amount:1000, cr_party: get_account.acid}
    body.merge!({ref_num:Faker::Code.isbn})
    @@create_transaction ||= Mpayer::Transaction.deposit(body)
    @@search_tran ||= Mpayer::Transaction.where(ref_id:@@create_transaction.ref_id)
		@@create_transaction
	end

	def get_transactions
		@@get_transactions ||= Mpayer::Transaction.all(from: Time.now -  (86400*400))
		@@get_transactions.any? ? @@get_transactions : [create_transaction]
	end


end