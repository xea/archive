require 'logger'
require 'observer'
require 'yaml'
require 'core/util'

# Represents a very flexible multilevel configuration object.
#
# The configuration directives are stored in a tree hierarchy and
# each node can be addressed with a path string. 
#
# Path nodes are separated by the dot (.) character.
#
# The recommended instantiation method is the get_instance which
# may accept the optional path argument. If this argument is present
# then the respective subtree is returned.
#
# When accessing non-existant nodes these are automatically created.

class Configuration
	SEPARATOR = '.'

	include Observable

	private_class_method :new
	
private
	@@instance = nil

public 
	# Factory method for instantiating the configuration. 
	#
	# Configuration subtrees are available via specifying the method id

	def self.get_instance(id = nil)
		if (id.nil?)
			@@instance = new unless @@instance
			return @@instance
		else
			return Subconfiguration.new(id)
		end
	end

	# Private constructor for initializing this object

	def initialize
		reset_defaults

		@log = Logger.new('log/configuration.log')
		@log.level = Logger::INFO
		@id = nil
	end

	# Restores the configuration data to the default values which defines a vanilla
	# system without connectors and other custom settings
	
	def reset_defaults
		@configuration = Hash.new
		@global_configuration = @configuration

		@configuration[:core] = Hash.new
		@configuration[:core][:loaded_connectors] = Hash.new
		@configuration[:core][:scheduler] = Hash.new
		@configuration[:core][:scheduler][:sleep_low] = 300
		@configuration[:core][:scheduler][:sleep_normal] = 60
		@configuration[:core][:scheduler][:sleep_high] = 10
		@configuration[:core][:scheduler][:last_low] = nil
		@configuration[:core][:scheduler][:last_normal] = nil
		@configuration[:core][:scheduler][:last_high] = nil
		@configuration[:global] = Hash.new
		@configuration[:global][:loglevel] = Logger::DEBUG
		@configuration[:global][:nodename] = "battery"
		@configuration[:global][:stats] = Hash.new
		@configuration[:global][:stats][:messages] = 0
		@configuration[:global][:stats][:startups] = 0
		@configuration[:global][:stats][:totaluptime] = 0
		@configuration[:connectors] = Hash.new
	end

	# Returns a hash containing the actual configuration

	def dump
		@configuration
	end

	def flatten(hash = nil, path = '')
		hash.assert_kind Hash, NilClass
		path.assert_kind String

		if (hash.nil?)
			hash = @configuration
		end


		list = Hash.new

		hash.each do |key, value|
			if (value.kind_of? Hash)
				list.merge! flatten(value, "#{path}#{key.to_s}.")
			else
				list["#{prefix}#{path}#{key}"] = hash[key]
			end
		end

		return list
	end

	def prefix
		@id.to_s.length > 0 ? "#{@id}." : ""
	end

	# Indicates whether the current configuration has the specified key or not

	def has_key?(key)
		key.assert_kind String, Symbol

		if (key =~ /[$!\[\],"'=>]/)
			return false
		end

		keyparts = key.to_s.split(Configuration::SEPARATOR)

		current_subtree = @configuration

		if keyparts.length > 0
			if (keyparts[0] == "global")
				current_subtree = @global_configuration
			end

			keyparts[0..-2].each do |keypart|
				if current_subtree.has_key? keypart.to_sym
					current_subtree = current_subtree[keypart.to_sym]
				else
					return false
				end
			end

			if current_subtree.has_key? keyparts[-1].to_sym
				return true
			else
				return false
			end
		else
			return false
		end
	end

	# Returns the value located in the specified node.

	def get(path)
		path.assert_kind String, Symbol

		current_subtree = @configuration
		
		if (path =~ /[$!\[\],"'=>]/)
			return nil
		end

		keyparts = path.to_s.split(Configuration::SEPARATOR)

		if (keyparts.length > 0)
			if (keyparts[0] == "global")
				current_subtree = @global_configuration
			end

			keyparts[0..-2].each do |keypart|
				if (current_subtree.has_key? keypart.to_sym)
					current_subtree = current_subtree[keypart.to_sym]
				else
					current_subtree[keypart.to_sym] = Hash.new
					current_subtree = current_subtree[keypart.to_sym]
				end
			end

			if current_subtree.has_key? keyparts[-1].to_sym
				return current_subtree[keyparts[-1].to_sym]
			else
				current_subtree[keyparts[-1].to_sym] = nil
				return current_subtree[keyparts[-1].to_sym]
			end
		else
			return @configuration
		end
	end

	def set(path, value)
		path.assert_kind String, Symbol

		current_subtree = @configuration

		if (value.class == Class)
			value = nil
		end
		
		if (path =~ /[$!\[\],"'=>]/)
			return nil
		end

		keyparts = path.to_s.split(Configuration::SEPARATOR)

		if (keyparts.length > 0)
			if (keyparts[0] == "global")
				current_subtree = @global_configuration
			end

			keyparts[0..-2].each do |keypart|
				if (current_subtree.has_key? keypart.to_sym)
					if (!current_subtree[keypart.to_sym].kind_of? Hash)
						current_subtree[keypart.to_sym] = Hash.new
					end
					current_subtree = current_subtree[keypart.to_sym]
				else
					current_subtree[keypart.to_sym] = Hash.new
					current_subtree = current_subtree[keypart.to_sym]
				end
			end

			current_subtree[keyparts[-1].to_sym] = value
		else
			return nil
		end
	end

	def delete(key)
		key.assert_kind String, Symbol

		if (has_key? key)
			parts = key.to_s.split(Configuration::SEPARATOR)

			parent = parts[0..-2].join(Configuration::SEPARATOR)
			sub = get(parent)

			sub.delete parts[-1].to_sym
		end
	end

	def increase(path, amount = 1)
		path.assert_kind String, Symbol
		amount.assert_kind Numeric, String

		if (path.kind_of? String and amount.kind_of? Numeric)
			set(path, get(path).to_i + amount.to_i)
		end
	end

	def decrease(path, amount = 1)
		if (path.kind_of? String and amount.kind_of? Numeric)
			set(path, get(path).to_i - amount.to_i)
		end
	end

	def load
		@configuration = YAML.load(File.open('configuration.yaml')) if File.exists? 'configuration.yaml'

		if @configuration == false
			reset_defaults
		end

		@log.info(:configuration) { "Notifying configuration observers" }
		changed
		notify_observers 1
	end

	def save
		begin
			@log.info(:configuration) { "Writing to disk" }

			File.open('configuration.yaml', 'w') do |file|
					YAML.dump(@configuration, file)
			end

			@log.info(:configuration) { "Save is complete" }
		rescue Exception => e
			p @configuration
		end
	end

	def class_invariant
		!@configuration.nil? and
		@configuration.kind_of? Hash and
		!@log.nil?
	end
end

class Subconfiguration < Configuration

	public_class_method :new

	attr_reader :id

	def initialize(id, create = false)
		id.assert_kind String, Symbol
		create.assert_kind FalseClass, TrueClass

		@log = Logger.new(STDOUT)
		@log.level = Logger::DEBUG

		if (id =~ /[\[\],"'=>]/)
			return nil
		end

		@id = id
		
		@global_configuration = Configuration.get_instance.dump
		@global_configuration.assert_kind Hash

		local_configuration = @global_configuration

		keyparts = id.to_s.split(Configuration::SEPARATOR)

		keyparts[0..-2].each do |keypart|

			if (local_configuration.has_key? keypart.to_sym)
				local_configuration = local_configuration[keypart.to_sym]
			else
				local_configuration[keypart.to_sym] = Hash.new
				
				local_configuration = local_configuration[keypart.to_sym]
			end
		end

		if (local_configuration.has_key? keyparts[-1].to_sym)
			@configuration = local_configuration[keyparts[-1].to_sym]
		else
			local_configuration[keyparts[-1].to_sym] = Hash.new

			@configuration = local_configuration[keyparts[-1].to_sym]
		end
	end
end

