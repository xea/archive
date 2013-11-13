class Route

	ACTION_LOG = :log
	ACTION_PUSH = :push

	attr_reader :actions
	attr_accessor :valid, :enabled
	attr_reader :name, :f_sifaces, :f_difaces, :f_priorities, :f_contents
	attr_reader :f_sconns, :f_schans, :f_sources 
	attr_reader :f_dconns, :f_dchans, :f_destinations
	
	def initialize(name = nil)
		@name = name.to_s
		@actions = []
		@enabled = false
		@valid = true
		
		@f_sifaces = []
		@f_difaces = []
		@f_sconns = []
		@f_dconns = []
		@f_schans = []
		@f_dchans = []
		@f_sources = []
		@f_destinations = []
		@f_priorities = []
		@f_contents = []
	end

	def valid?
		@valid
	end

	def enabled?
		@enabled
	end
	
	def match_source_interface(interface = '*')
		@f_sifaces << interface unless @f_sifaces.member? interface or interface.nil?
		self
	end

	def unmatch_source_interface(interface = '*')
		@f_sifaces.delete interface unless @f_sifaces.member? interface or interface.nil?
		self
	end
	
	def match_destination_interface(interface = '*')
		@f_difaces << interface unless @f_difaces.member? interface or interface.nil?
		self
	end

	def unmatch_destination_interface(interface = '*')
		@f_difaces.delete interface unless @f_difaces.member? interface or interface.nil?
		self
	end

	def match_source_connector(connector = '*')
		@f_sconns << connector unless @f_sconns.member? connector or connector.nil?
		self
	end

	def unmatch_source_connector(connector = '*')
		@f_sconns.delete connector if @f_sconns.member? connector or connector.nil?
		self
	end

	def match_destination_connector(connector = '*')
		@f_dconns << connector unless @f_dconns.member? connector or connector.nil?
		self
	end

	def unmatch_destination_connector(connector = '*')
		@f_dconns.delete connector if @f_dconns.member? connector or connector.nil?
		self
	end
	
	def match_source_channel(channel = '*')
		@f_schans << channel unless @f_dchans.member? channel or channel.nil?
		self
	end

	def unmatch_source_channel(channel = '*')
		@f_schans.delete channel if @f_schans.member? channel or channel.nil?
		self
	end

	def match_destination_channel(channel = '*')
		@f_dchans << channel unless @f_schans.member? channel or channel.nil?
		self
	end

	def unmatch_destination_channel(channel = '*')
		@f_dchans.delete channel if @f_dchans.member? channel or channel.nil?
		self
	end

	def match_source(source = '*')
		@f_sources << source unless @f_sources.member? source or source.nil?
		self
	end

	def unmatch_source(source = '*')
		@f_sources.delete source if @f_sources.member? source or source.nil?
		self
	end

	def match_destination(destination = '*')
		@f_destinations << destination unless @f_destinations.member? destination or destination.nil?
		self
	end

	def unmatch_destination(destination = '*')
		@f_destinations.delete destination if @f_destinations.member? destination or destination.nil?
		self
	end

	def match_priority(priority = Message::PRIORITY_NORMAL)
		@f_priorities << priority unless @f_priorities.member? priority or priority.nil?
		self
	end

	def unmatch_priority(priority = Message::PRIORITY_NORMAL)
		@f_priorities.delete priority if @f_priorities.member? priority or priority.nil?
		self
	end

	def match_content(content = '')
		@f_contents << content unless @f_contents.member? content or content.nil?
		self
	end

	def unmatch_content(content = '')
		@f_contents.delete content if @f_contents.member? content or content.nil?
		self
	end

	def add_action(action)
		@actions << action
	end

	def remove_action(action)
		@actions.delete action
	end

	def match?(message)
		if (@f_sifaces.length == 0 and
			@f_difaces.length == 0 and
			@f_sconns.length == 0 and
			@f_dconns.length == 0 and
			@f_schans.length == 0 and
			@f_dchans.length == 0 and
			@f_sources.length == 0 and
			@f_destinations.length == 0 and
			@f_priorities.length == 0 and
			@f_contents.length == 0)
			return false
		end

		r = nil

		r = @f_sifaces.find_all do |filter|
			message.source_connector.class::INTERFACE_NAME.to_s =~ Regexp.new('^' + filter.to_s.sub(/\*/, '.*?') + '$')
		end unless @f_sifaces.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_difaces.find_all do |filter|
			message.destination_connector.class::INTERFACE_NAME.to_s =~ Regexp.new('^' + filter.to_s.sub(/\*/, '.*?') + '$')
		end unless @f_difaces.length == 0

		return false if !r.nil? and r.length == 0
		
		r = nil

		r = @f_sconns.find_all do |filter|
			message.source_connector.name.to_s =~ Regexp.new('^' + filter.to_s.sub(/\*/, '.*?') + '$')
		end unless @f_sconns.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_dconns.find_all do |filter|
			message.destination_connector.name.to_s =~ Regexp.new('^' + filter.to_s.sub(/\*/, '.*?') + '$')
		end unless @f_dconns.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_schans.find_all do |filter|
			message.source_channel.to_s =~ Regexp.new('^' + filter.to_s.sub(/\*/, '.*?') + '$')
		end unless @f_schans.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_dchans.find_all do |filter|
			message.destination_channel.to_s =~ Regexp.new('^' + filter.to_s.sub(/\*/, '.*?') + '$')
		end unless @f_dchans.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_sources.find_all do |filter|
			message.source.to_s =~ Regexp.new('^' + filter.to_s.sub(/\*/, '.*?') + '$')
		end unless @f_sources.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_destinations.find_all do |filter|
			message.destination.to_s =~ Regexp.new('^' + filter.sub(/\*/, '.*?') + '$')
		end unless @f_destinations.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_priorities.find_all do |filter|
			message.priority.to_s =~ Regexp.new(filter.to_s.sub(/\*/, '.*?'))
		end unless @f_priorities.length == 0

		return false if !r.nil? and r.length == 0

		r = nil

		r = @f_contents.find_all do |filter|
			message.content.to_s =~ Regexp.new(filter.to_s.sub(/\*/, '.*?'))
		end unless @f_contents.length == 0

		return false if !r.nil? and r.length == 0

		true
	end

	def clear
		[ @f_sifaces, @f_sconns, @f_sources, @f_destinations, @f_priorities, @f_contents ].each do |filter|
			filter.clear
		end
	end
end

class Action
	LOG = :log
	PUSH = :push
	PRIORIZE = :priorize
	ENCRYPT = :encrypt
	HIDE = :hide

	attr_reader :action
	attr_reader :args

	def initialize(action, args = {})
		action.assert_kind Symbol
		args.assert_kind Hash

		@action = action if action.kind_of? Symbol
		@args = args if args.kind_of? Hash
	end

	def action=(action)
		action.assert_kind Symbol

		@action = action if action.kind_of? Symbol
	end

	def args=(args)
		args.assert_kind Hash

		@args = args if args.kind_of? Hash
	end

	def class_invariant
		@action.kind_of? Symbol and
		(@args.nil? or @args.kind_of? Hash)
	end
end
