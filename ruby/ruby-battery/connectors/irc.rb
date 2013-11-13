require 'core/connector'
require 'core/interface'
require 'core/message'
require 'lib/irc'
require 'socket'
require 'timeout'

class IrcConnector < Connector
	API_MAJOR_VERSION = 3
	API_MINOR_VERSION = 1

	INTERFACE_NAME = :irc

	def initialize(name = "irc-#{@@next_id + 1}")
		super name

		@cfg.set('server', 'localhost') 	if @cfg.get('server').nil?
		@cfg.set('port', 6667)			if @cfg.get('port').nil?
		@cfg.set('username', 'battery')	if @cfg.get('username').nil?
		@cfg.set('nickname', 'battery')	if @cfg.get('nickname').nil?
		@cfg.set('realname', 'battery')	if @cfg.get('realname').nil?

		@sockmutex = Mutex.new
		@client = nil
	end

	def update(key)

	end

	def main
		update(1)

		@log.info(sym) { "Entering main loop" }

		@log.info(sym) { "Connecting to #{@cfg.get('server')}:#{@cfg.get('port')}" }

		@state = Interface::STATE_CONNECTING

		@client = IRCClient.new

		@client.on_established { 
			@client.nick(@cfg.get('nickname'))
			@client.user(@cfg.get('username'),
						 'localhost',
						 'localhost',
						 @cfg.get('realname'))
		}

		@client.on_connect { |event| 
			@state = Interface::STATE_ONLINE
			@log.info(sym) { "Connection established, logging in" } 
			
			@channels.find_all { |name, channel| channel.enabled? }.each do |name, channel|
				if (channel.name[0] == '#')
					@client.join channel.name
				else
					@client.join "##{channel.name}"
				end
			end
		}

		@client.on_disconnect { |event|
			@state = Interface::STATE_OFFLINE
			@log.info(sym) { "Disconnected" }
		}

		@client.on_raw { |input|
			@log.info(sym) { input };
		}

		@client.on_motd { |event|
		}

		@client.on_join { |event|
			channel_name = event.params[0].tr('#', '')
			nickname = event.prefix.split('!')[0]

			if (nickname == @cfg.get('nickname'))
				if (!@channels.has_key? channel_name)
					add_channel(channel_name)
				end

				@channels[channel_name].infoline = "joined"
				@channels[channel_name].state = :on
			else
				@channels[channel_name].members << event.prefix
			end
		}

		@client.on_part { |event|
			channel_name = event.params[0].tr('#', '')
			@channels[channel_name].state = :off if @channels.has_key? channel_name
		}

		@client.on_kick { |event|
			channel_name = event.params[0].tr('#', '')
			names = event.params[1..-2]
			reason = event.params[-1]

			if (names.member? @cfg.get('nickname'))
				if @channels.has_key? channel_name
					@channels[channel_name].state = :off 
					@channels[channel_name].infoline = "kicked: #{reason}" 
				end
			end
		}

		@client.on_privmsg { |event| 
			msg = Message.new
			msg.source_connector = self
			msg.content = event.params[-1]
			msg.source_channel = event.params[0].tr('#', '') if event.params[0][0] == '#'
			msg.source = event.prefix.split('!')[0]

			if msg.content.to_s =~ /^([^:\s]+):/
				msg.destination = $1
			end

			@log.debug(sym) { "#{event.params}" }

			@queue.enq msg
		}

		@client.connect(@cfg.get('server'), @cfg.get('port').to_i)

		begin
			sleep
		rescue Exception => e
		end
	end

	def disconnect
		if (@state == Interface::STATE_ONLINE)
			@client.quit('shutting down')

			super 

			@channels.each do |name, channel|
				channel.state = :off
				channel.infoline = ""
			end

			@state = Interface::STATE_OFFLINE
			return false
		else
			@state = Interface::STATE_OFFLINE
			return true
		end
	end

	override
	def synchronize_channels
		@channels.each do |name, channel|
			if channel.enabled? and (channel.state == :off or channel.state == :kicked)
				@client.join "##{name}" unless @client.nil?
			elsif !channel.enabled? and (channel.state == :on)
				@client.part "##{name}" unless @client.nil?
			end
		end
	end

	def infoline
		"#{@cfg.get('server')}:#{@cfg.get('port')}/#{@cfg.get('nickname')}"
	end

	def send(object)
		if (object.kind_of? Message)
			send_irc(object)
		elsif (object.kind_of? Envelope)
			object.messages.each do |msg|
				send_irc(msg)
			end
		end
	end

	def send_irc(object)
		if (object.destination_channel.to_s.length == 0)
			@client.privmsg("#{object.destination.to_s}", object.content)
		else
			if (object.destination.to_s.length == 0)
				@client.privmsg("##{object.destination_channel.to_s}", "#{object.content}")
			else
				@client.privmsg("##{object.destination_channel.to_s}", "#{object.destination.to_s}: #{object.content}")
			end
		end
	end

	def join_channel(channel)
		@client.join("##{channel.name}") unless @client.nil? or !@client.enabled?
	end

	def leave_channel(channel)
		@client.part("##{channel.name}") unless @client.nil?
	end

end
