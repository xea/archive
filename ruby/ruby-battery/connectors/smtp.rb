require 'net/smtp'
require 'core/connector'
require 'core/message'
require 'thread'

class SmtpConnector < Connector
	API_MAJOR_VERSION = 3
	API_MINOR_VERSION = 1

	INTERFACE_NAME = :smtp
	
	def initialize(name = "smtp-#{@@next_id + 1}")
		super name

		@cfg.set('server', 'localhost') if @cfg.get('server').nil?
		@cfg.set('from', 'battery@localhost') if @cfg.get('from').nil?
		@cfg.set('subject', 'battery status update') if @cfg.get('subject').nil?
		@cfg.set('to', 'user@localhost') if @cfg.get('to').nil?
		@cfg.set('sleep_interval', 10) if @cfg.get('sleep_interval').nil?
		@cfg.set('login_user', 'username') if @cfg.get('login_user').nil?
		@cfg.set('login_pass', 'password') if @cfg.get('login_pass').nil?

		@sender_queue = Queue.new
	end
	
	override
	def main
		begin
			@log.info(sym) { "[main]" }
			@log.info(sym) { "[connected]" }
			@state = Interface::STATE_ONLINE
			while true
				if (@sender_queue.length > 0)
					@log.info(sym) { "[bulking] #{@sender_queue.length} message(s)" }
					list = []

					while @sender_queue.length > 0
						message = @sender_queue.deq

						list << "#{message.date} <#{message.source}@#{message.destination}/#{message.source_connector.name}> #{message.content}"
					end

					message = list.join("\n")

					Net::SMTP.start(@cfg.get('server'), 25) do |smtp|
						smtp.open_message_stream(@cfg.get('from'), [@cfg.get('to')]) do |f|
							f.puts "From: #{@cfg.get('from')}"
							f.puts "To: #{@cfg.get('to')}"
							f.puts "Subject: #{@cfg.get('subject')}"
							f.puts
							f.puts message
						end
					end

					@log.info(sym) { "[send]" }
				else
					sleep @cfg.get('sleep_interval').to_i
				end
			end
			@log.info(sym) { "[disconnected]" }

			@log.info(sym) { "[main] end" }
		rescue ShutdownEvent => event
			@log.info(sym) { "[shutdown]" }
		rescue Exception => e
			Util.handle_exception e
		end
	end

	override
	def send(message)
		if (message.kind_of? Message)
			
		elsif (message.kind_of? Envelope)
			@log.debug(sym) { "[send envelope] #{message.messages.length}" }
			message.messages.each do |msg|
				@sender_queue.enq msg
			end
		end
	end
end

