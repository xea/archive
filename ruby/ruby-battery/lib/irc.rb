require 'socket'
require 'strscan'
require 'timeout'

class IRCClient

	def initialize
		@handlers = Hash.new
		@socket_mutex = Mutex.new
		@event_connect		= lambda {}
		@event_disconnect	= lambda {}
	end
	
	def method_missing(method, *args, &block)
		if (method.to_s =~ /^on_(\w+)$/i)
			if block_given?
				@handlers["#{$1}".to_sym] = block
			else
				if @handlers.has_key? $1.to_sym
					r = @handlers[$1.to_sym].call(*args)
				end
			end
		end
	end

	def read
		input = nil

		if (!@socket.nil?)

			res = select([@socket], nil, nil, 0.5)
			
			if (!res.nil? and res[0].length > 0)
				@socket_mutex.synchronize do
					input = @socket.gets.strip
				end
			end
		end

		input
	end

	def write(msg)
		if (!@socket.nil?)
			res = select(nil, [@socket], nil, 0.5)

			if (!res.nil? and res[1].length > 0)
				@socket_mutex.synchronize do
					@socket.puts msg
				end
			end
		end
	end

	def translate(input)
		translationtable = {
			1 => "welcome",
			2 => "yourhost",
			3 => "created",
			4 => "myinfo",
			5 => "bounce",
			221 => "umodeis",
			301 => "away",
			302 => "userhost",
			303 => "ison",
			305 => "unaway",
			306 => "nowaway",
			311 => "whoisuser",
			312 => "whoisserver",
			313 => "whoisoperator",
			314 => "whowasuser",
			315 => "endofwho",
			317 => "whoisidle",
			318 => "endofwhois",
			319 => "whoischannels",
			324 => "channelmodeis",
			331 => "notopic",
			332 => "topic",
			352 => "whoreply",
			366 => "endofnames",
			369 => "endofwhowas",
			372 => "motd",
			375 => "motdstart",
			376 => "connect",
			401 => "err_nosuchnick",
			402 => "err_nosuchserver",
			403 => "err_nosuchchannel",
			404 => "err_cannotsendtochan",
			405 => "err_toomanychannels",
			406 => "err_wasnosuchnick",
			411 => "err_norecipient",
			412 => "err_notexttosend",
			421 => "err_unknowncommand",
			422 => "connect", # err_nomotd
			431 => "err_nonicknamegiven",
			432 => "err_erroneusnickname",
			433 => "err_nicknameinuse",
			436 => "err_nickcollision",
			442 => "err_notonchannel",
			443 => "err_useronchannel",
			444 => "err_nologin",
			461 => "err_needmoreparams",
			464 => "err_passwdmismatch",
			465 => "err_yourebannedcreep",
			474 => "err_bannedfromchan"
		}

		if (input.to_i > 0)

			if (translationtable[input.to_i].nil?)
				return "num#{num}"
			else
				return translationtable[input.to_i]
			end
		else
			return input
		end
	end

	def main
		while true
			input = read

			if input.nil?
				sleep 1
			else
				if @handlers.has_key? :raw
					on_raw input
				end

				event = IRCCommand.parse(input)

				if (event.command =~ /ping/)
					pong event.params[0]
				else
					handler = "on_#{translate(event.command)}".to_sym				

					self.send handler, event
				end
			end
		end
	end

	def connect(server, port, ssl = false)
		begin
			Timeout::timeout(1) do |time|
				@socket = TCPSocket.new(server, port.to_i)
			end

			@worker_thread = Thread.new do 
				main
			end

			on_established
		rescue Timeout::Error
			on_disconnect 'Connection timeout'
		rescue Errno::ENOTCONN
			on_disconnect 'Connection failed'
		end
	end

	def disconnect
		@socket.close unless @socket.nil?

		on_disconnect 'Quit reason'
	end

	def join(channel)
		write("JOIN #{channel.to_s}")
	end

	def kick(nickname, reason)
		write("KICK #{nickname.to_s} :#{reason.to_s}")
	end

	def mode(nickname, mode)
	end

	def nick(nickname)
		write("NICK #{nickname.to_s}")
	end

	def part(channel)
		write("PART #{channel.to_s}")
	end

	def pass(password)
		write("PASS #{password.to_s}")
	end

	def pong(id)
		write("PONG :#{id.to_s}")
	end
	
	def privmsg(destination, message)
		write("PRIVMSG #{destination} :#{message}")
	end
	
	def quit(reason)
		write("QUIT :#{reason.to_s}")
	end

	def user(username, hostname, servername, realname)
		write("USER #{username} #{hostname} #{servername} :#{realname}")
	end
end

class IRCCommand
	attr_reader :prefix
	attr_reader :command
	attr_reader :params
	attr_reader :raw

	def initialize(prefix, command, params, raw)
		@prefix = prefix
		@command = command
		@params = params
		@raw = raw
	end

	def self.parse(input)
		scn = StringScanner.new(input.strip)

		prefix = nil
		command = nil
		params = Array.new

		if scn.scan(/^:(\S+)\s*/) != nil
			prefix = scn[1]
		end

		scn.scan(/^([a-zA-Z0-9]+)/)

		command = scn[1].downcase

		if (scn.rest.split.length < 16)
			subparams = scn.rest.split(/\B:/, 2)
			params += subparams[0].to_s.split
			params << subparams[1].sub(/^:/, '') unless subparams[1].nil?
		else
			params = scn.rest.split(/\s/, 16)
		end

		params.delete nil

		IRCCommand.new(prefix, command, params, input.strip)
	end
end

