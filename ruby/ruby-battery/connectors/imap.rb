require 'net/imap'
require 'core/connector'
require 'core/message'

class ImapConnector < Connector

	API_MAJOR_VERSION = 3
	API_MINOR_VERSION = 1

	INTERFACE_NAME = :imap
	
	def initialize(name = "imap-#{@@next_id + 1}")
		super name

		@cfg.set('server', 'localhost') if @cfg.get('server').nil?
		@cfg.set('port', 143) if @cfg.get('port').nil?
		@cfg.set('username', 'user@localhost') if @cfg.get('username').nil?
		@cfg.set('password', 'password') if @cfg.get('password').nil?

	end

	def update(key)
	end

	def main
		@log.info(sym) { "[main]" }
		imap = Net::IMAP.new(@cfg.get('server'))
		imap.login(@cfg.get('username'), @cfg.get('password'))
		@log.info(sym) { "[connected]" }
		while true
			imap.examine('INBOX')
			imap.search('UNSEEN').each do |message_id|
				envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
				body = imap.fetch(message_id, "BODY[TEXT]")

				message = Message.new
				message.source_connector = self
				message.source_channel = envelope.from[0].host
				message.source = envelope.from[0].mailbox
				message.destination = envelope.to[0].mailbox
				message.destination_channel = envelope.to[0].host
				message.content = body.to_s

				@log.info(sym) { "[incoming message] from: #{message.source}@#{message.source_channel}" }

				@queue.enq message
			end

			sleep 10

			imap.noop
		end
	end

	override
	def disconnect
	end
end

