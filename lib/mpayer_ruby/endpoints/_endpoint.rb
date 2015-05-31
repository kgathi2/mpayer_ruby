module Mpayer
	class Endpoint
		attr_accessor :config, :response, :pagination, :endpoint, :attributes
		attr_accessor :id

		# Mpayer::Model.new(options={})
		def initialize(config:nil,**keyword_args)
			@attributes = Hashie::Mash.new(keyword_args)
			keyword_args.each do |k,v|
				self.send("#{k.to_s}=",v) rescue nil
			end
			@config = set_config(config)
	    # @is_new ||= true
	    @pagination  ||= {}
	    after_initialize
		end

		def id=(value)
			raise Exception, "Mpayer Object ID cannot be nil" if value.nil? and attributes.deleting.nil?
			@id = value
		end

		protected

		def kill
			instance_variables.each{|var| instance_variable_set(var,nil)}
			freeze
		end

		# after_initialize{ @endpoint = 'clients'}
		# class << self
		# 	# Used to instantiate new objects instead of using def initialize
		# 	def after_initialize#(&block)
		# 		# block.call
		# 		# yield if block_given?
		# 		yield
		# 	end
		# end

		def after_initialize
			
		end

		# Use this methon in the association reader method witht the same name
		def find_all(page:1,per_page:100,**options)
			# gets caller methods as association
			association =  caller_locations(1,1)[0].label 
			url = assoc_link(association.to_sym,options)
			if self.pagination[association]=={per_page:per_page,page:page} 
				self.send("#{association}=", Mpayer::Fetch.get(url,query:{page:page,per_page:per_page}) ) if instance_variable_get("@#{association}").nil?
			else
				self.send("#{association}=", Mpayer::Fetch.get(url,query:{page:page,per_page:per_page}) )
			end
			self.pagination.merge!({"#{association}":{page:page,per_page:per_page}})
			return instance_variable_get("@#{association}")
		end

		def assoc_link(association,**options)
			case association
			when :transactions
				raise ArgumentError if options[:account_id].nil?
				"/#{self.endpoint}/#{self.id}/accounts/#{options[:account_id]}/#{association}"
			else # :accounts, :payables, :members
				"/#{self.endpoint}/#{self.id}/#{association}"
			end
		end

		# def self.has_associations(*attr_names)
		# 	attr_names.each do |attr_name|
		# 		# writers
		# 		define_method("#{attr_name}=") do |value|
		# 			instance_variable_set("@"+attr_name.to_s, value)
		# 		end
		# 		#readers
		# 		define_method(attr_name) do
		# 			instance_variable_get("@"+attr_name.to_s)
		# 		end
		# 	end
		# end

		def set_config(configuration)
			config = Mpayer.configuration.clone
			unless configuration.nil?
				config.user_no = configuration[:user_no]
				config.token = configuration[:token]
			end
			config
		end

		def method_missing(m, *args, &block)
			if @response.is_a?(Hash)
				@response.keys.include?(m.to_s) ? @response.send(m) : super
			else
				super
			end
		end

	end
end