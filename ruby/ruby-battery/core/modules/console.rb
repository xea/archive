require 'core/table'

class ConsoleContext
	attr_accessor :path, :arg
end

module Console

	# This is the global command table collectiong those functions that can be issued
	# from the console. The entries are consisted by the following parts:
	#
	# * command :	this is the command that has to be typed in the console to execute
	#				the command. Where the command has substrings surrounded with <>'s
	#				a named argument is required. The handler method gets these vars
	#				in a hash identified by the specified name
	#
	# * method :	the name of the method to be called when executing the command
	#
	# * mode :		an array containing the symbols of the console modes where this 
	#				command can be issued
	#
	# * visible :	indicated whether the command must be displayed in the help topics
	#				or not
	#
	# * description: the textual description of the command. This text is displayed
	#				when help messages are needed
	
	@@command_table = [
		{ command: '?',	method: :con_help,	mode: [ :all ], visible: false,
			description: '',
			help: '' },
		{ command: 'commands',	method: :con_help,	mode: [ :all ], visible: true,
			description: 'Shows description for those commands that are available from the current context',
			help: '' },
		{ command: 'exit',	method: :con_exit,	mode: [ :all ], visible: true,
			description: 'Exits from the current console mode',
			help: '' },
		{ command: 'feedback <switch>', method: :con_switch_feedback,	mode: [ :all ], visible: true,
			description: 'Sets console feedback on or off',
			help: '' },
		{ command: 'help <command>', method: :con_help_command,	mode: [ :all ], visible: true,
			description: 'Shows help for a specific command',
			help: '' },
		{ command: 'quit',	method: :con_quit,	mode: [ :all ],	visible: true,
			description: 'Immediately quits the console',
			help: '' },
		{ command: 'show path',	method: :con_show_path,	mode: [ :all ], visible: false,
			description: 'Shows the current console path',
			help: '' },
	]

	def self.feature
		:"dynamic console"
	end

	def self.extended(mod)
	end

	def init_module
		add_hook 'pre_bootstrap', 'console', lambda { init_console }
		add_hook 'main', 'console', lambda {
			puts "#{Core::APPLICATION_LONG_NAME} v#{Core::API_MAJOR_VERSION}.#{Core::API_MINOR_VERSION}"
			puts "Type 'commands' for a list of available commands"
			puts

			start_console
		}
	end

	def init_console
		@console_path = [ :init ]
		@command_history = []
		@context_arg = nil
		@console_feedback = true
	end

	def start_console
		context = ConsoleContext.new
		context.path = [ :init ]
		context.arg = nil


		catch(:exit) do
			while true
				print prompt

				input = gets

				throw :exit if input.nil?

				input.strip!

				if (input !~ /^\s*$/)
					command = lookup_command input

					if (command == :ambigious)
						puts "ambigious command"
					elsif (command == :none)
						puts "command not found"
					else
						execute_command(command)
					end
				end
			end
		end
	end

	def execute_command(command)
		command.assert_kind Hash, NilClass

		if command
			input = nil # Input is still used for compatibility purposes

			call_hook('execute_console_command', command)
			@command_history << input
			self.send(command[:method], input, command[:args])
		end
	end

	def prompt
		char = console_mode == :init ? '$' : '#'
		"#{@configuration.get('global.nodename')}(#{console_mode.to_s})#{char} "
	end

	def console_mode(mode = nil)
		mode.nil? ? @console_path.last : @console_path.push(mode)
	end

	def context_arg
		@console_path.last.to_s.split[-1]
	end

	def cprint(msg)
		print msg if @console_feedback
	end

	def cputs(msg)
		puts msg if @console_feedback
	end

	def cp(obj)
		p obj if @console_feedback
	end

	def lookup_command(input)
		input.assert_kind String, NilClass

		mod_input = input.to_s.chomp.strip

		delim = '/'

		path_parts = mod_input.split('/').reject { |p| p.to_s.length == 0 }

		return nil if path_parts.length == 0

		path_elements = path_parts[0...-1]
		c_command = path_parts[-1]
		parts = c_command.to_s.scan(/"[^"]+"|\S+/)

		current_path = @console_path

		if (path_elements.length > 0)
			current_path = path_elements.collect { |e| e.to_sym }

			if (current_path[0] != "init")
				current_path.insert(0, :init)
			end
		end

		@context_arg = current_path[-1].to_s.split[1]

		candidate_commands = @@command_table.clone

		candidate_commands = candidate_commands.find_all { |command|
			command[:mode].member? current_path[-1].to_s.split[0].to_sym or command[:mode].include? :all
		}.find_all { |command|
			command[:command].split.length == parts.length
		}

		parts.each_with_index do |part, i|
			part.gsub!(/[?]/, '\?') 

			regexp = Regexp.new "^#{part}"

			candidate_commands = candidate_commands.find_all { |command|
				command_parts = command[:command].tr('!@#$%', ' ').split

				command_parts[i] =~ regexp or command_parts[i] =~ /^<\w+>$/ or command_parts[i] =~ /^\[\w+\]$/
			}
		end

		if candidate_commands.length > 1
			return :ambigious
		elsif candidate_commands.length == 1
			command = candidate_commands[0]

			command_parts = command[:command].tr('!@#$%', ' ').split

			i = 0

			args = Hash.new

			parts = parts.collect { |part|
				if (part.length > 1 and part[0] == '"' and part[-1] == '"')
					part.tr!('"', '')
				else
					part.split(/[!\#$@%]/)
				end
			}.flatten

			while i < command_parts.length
				if command_parts[i] =~ /^<(\w+)>$/
					args[$1.to_sym] = parts[i]
				elsif command_parts[i] =~ /^\[(\w+)\]$/
					args[$1.to_sym] = parts[i]
				end

				i += 1
			end

			command[:args] = args

			return command
		end

		return :none
	end

	def con_exit(input, args)
		@context_arg = nil
		if (console_mode == :init)
			throw :exit
		else
			return @console_path.pop
		end
	end

	def con_help(input, args)
		table = Table.new('-s', '-s')
		table.set_header('Command', 'Description')

		context_commands = @@command_table.find_all { |command| 
			command[:visible] and 
			!command[:mode].member? :all and 
			command[:mode].member? console_mode.to_s.split[0].to_sym
		}.sort_by { |command| command[:command] }

		global_commands = @@command_table.find_all { |command| 
			command[:visible] and 
			command[:mode].member? :all
		}.sort_by { |command| command[:command] }

		context_commands.each do |command|
			table.add_row(command[:command], command[:description])
		end

		table.add_row('', '') unless global_commands.length == 0 or context_commands.length == 0

		global_commands.each do |command|
			table.add_row(command[:command], command[:description])
		end

		table.print
	end

	def con_help_command(input, args)
		cmd = args[:command].to_s 

		command = lookup_command(cmd)

		if command
			puts "COMMAND"
			puts "  #{command[:command]}"
			puts "MODES:"
			puts "  #{command[:mode].collect { |m| m.to_s }.join(',')}"
			puts "DESCRIPTION"
			puts "  #{command[:description]}"
			puts "HELP" 
			if (command[:help].length > 0)
				command[:help].split("\n").each do |line|
					puts "  #{line}"
				end
			else
				puts "  No help available for this command"
			end
		else
			puts "No such command"
		end
	end

	def con_quit(input, args)
		throw :exit
	end

	def con_show_path(input, args)
		@console_path.each do |element|
			print " #{element} >"
		end

		puts
	end

	def con_switch_feedback(input, args)
		@console_feedback = args[:switch] == 'on' ? true : false

		cputs "console feedback is now turned on"
	end
end

load 'core/modules/console_init.rb'
load 'core/modules/console_priv.rb'
load 'core/modules/console_config.rb'
load 'core/modules/console_interfaces.rb'
load 'core/modules/console_connectors.rb'
load 'core/modules/console_debug.rb'
load 'core/modules/console_trace.rb'
load 'core/modules/console_threads.rb'
load 'core/modules/console_router.rb'
load 'core/modules/console_health.rb'
load 'core/modules/console_statistics.rb'
