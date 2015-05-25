# Mpayer

[![Build Status](https://travis-ci.org/kgathi2/mpayer_ruby.svg)](https://travis-ci.org/kgathi2/mpayer_ruby)  [![Gem Version](https://badge.fury.io/rb/mpayer_ruby.svg)](http://badge.fury.io/rb/mpayer_ruby)  [![Coverage Status](https://coveralls.io/repos/kgathi2/mpayer_ruby/badge.svg)](https://coveralls.io/r/kgathi2/mpayer_ruby)

A ruby client that makes it easy to integrate to [Mpayer payment gateway](http://mpayer.co.ke). It allows for railsesque way of interacting with Mpayer objects. Is compatible currently with Mpayer version 1

## Installation

Add this line to your application's Gemfile:

gem requires `ruby ~>2.0`

```ruby
gem 'mpayer_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mpayer_ruby

## Usage

First thing is to get the credentials of an Mpayer teller. This are the stored as environment variables. Add the following to your `~/.bash_profile` file or wherever else you load ENV variables

```sh
export MPAYER_USER=<Your User name>
export MPAYER_TOKEN=<Your token>
```

## Configurations
To configure credentials locally on you code use config block below. For Rails, put this in `config/initializers/mpayer.rb`

```ruby
Mpayer.setup do |config|
	config.user_no = <Your User name>
	config.token = <Your token>
end
```

Versioning is not currently supported. 

## Quick Example

```ruby
require "rubygems"
require "mpayer_ruby"

Mpayer.setup do |config|
	config.user_no = <USER>
	config.token = <TOKEN>
end

#Get all clients in your organisation
clients = Mpayer::Client.all(per:1,per_page:100)

#Get one client in your organisation
clients = Mpayer::Client.find(123)

#Instantiate without http call, obviously if you know that the client exists
clients = Mpayer::Client.find(123, fetch:false)
```

## Endpoints
Mpayer gem currently supports a few endpoint below 

https://app.mpayer.co.ke/api/client
https://app.mpayer.co.ke/api/accounts
https://app.mpayer.co.ke/api/transactions
https://app.mpayer.co.ke/api/payables

All responses are objects and can be accessed with dot notation
e.g 
```ruby
clients = Mpayer::Client.all(per:1,per_page:100) 
client = client.first
client.name #=> "CLark Kent"
```

### Client
```ruby
clients = Mpayer::Client.all

client = Mpayer::Client.find(id)  #Instantiates and hits the api
client = Mpayer::Client.find(id, fetch:false) #Instantiates only

client_attributes = {client: { client_name: "Kiki Lolo", client_birthday: Time.now.iso8601, client_type: "ext", ac_type: "cu",client_mobile: '0733222222', client_email: 'lolo@kiki.com',currency: "kes", mandate:"s", sub_type: "od" }}
client = Mpayer::Client.create(client_attributes)

client = Mpayer::Client.find(id:20284,fetch:false).account(account_id) # Get clients account with id
client = Mpayer::Client.find(id:20284,fetch:false)
account = client.account(account_id) # Get clients account with id

client_accounts = Mpayer::Client.find(id:20284,fetch:false).accounts(per:1,per_page:100)
client_payables = Mpayer::Client.find(id:20284,fetch:false).payables(per:1,per_page:100)
client_transactions = Mpayer::Client.find(id:20284,fetch:false).transactions(account_id, per:1,per_page:100)

```

### Account

```ruby
accounts = Mpayer::Account.all
account = Mpayer::Account.find(1) #Instantiates and hits the api
account = Mpayer::Account.find(1, fetch:false) #Instantiates only

account = Mpayer::Account.find(1, fetch:false)
account.update(name:'Lolo Kiki')

options = {from_date: Time.now -  (86400*365),to_date:nil, dr_cr:nil, ac_type:nil, category:nil}
accounts = Mpayer::Account.aggregates(options)

members = Mpayer::Account.find(25735, fetch:false).members

payable_items = Mpayer::Account.find(25735, fetch:false).payable_items

```

### Payable


```ruby
payables = Mpayer::Payable.all
payable = Mpayer::Payable.find(id) #Instantiates and hits the api
payable = Mpayer::Payable.find(id,fetch:false) #Instantiates only

Mpayer::Payable.where(ref_id:"Ksdfsfsdf000411") #Search for payable. only ref_id supported currently

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
		client_id: client_id, 
		status: status,
		payable_type: payable_type,
		due_date: Time.now+(86400*31), 
		pay: payable_items,
		tags: tags,
		flags: flags,
		infos: infos ,
		sync_lag:sync_lag
	}
}
payable = Mpayer::Payable.create(options)

payable = Mpayer::Payable.find(8818,fetch:false)
payable.destroy# Delete a payable
```

### Transactions

```ruby
# Note: cr_party is the recieving (credited) account while dr_party is paying (debited) account

transactions = Mpayer::Transaction.all(from: Time.now -  (86400*400))

transaction = Mpayer::Transaction.where(ref_id:"KT00410000402")# Only ref_id supported currently

body = {particulars:"particulars",amount:1000, cr_party: "account_alias"}
deposit = Mpayer::Transaction.deposit(body)

body = {particulars:"particulars",amount:10, dr_party: "01202320320"}
withdrawal = Mpayer::Transaction.withdraw(body)

body = {particulars:"particulars",amount:10, cr_party: "02304304", dr_party:"alias" }
transfer = Mpayer::Transaction.transfer(body)

```

### Fetch
```ruby
# Used to interact with https://app.mpayer.co.ke/api

Mpayer.setup do |config|
	config.user_no = 'GLOBAL_USER'
	config.token = 'GLOBAL_TOKEN'
end

url = "/clients/all_clients"
Mpayer::Fetch.get(url,query:{per:per,per_page:per_page})
Mpayer::Fetch.post(url,body:{client:{name:'Kiki Lolo'}}.to_json)
Mpayer::Fetch.put(url,body:{client:{name:'Kiki Lolo'}}.to_json)
Mpayer::Fetch.delete(url)

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Todo
1. Add Webmock for faster / localised test or sinatra app method
2. Add versioning


## Contributing

1. Fork it ( https://github.com/[my-github-username]/mpayer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
