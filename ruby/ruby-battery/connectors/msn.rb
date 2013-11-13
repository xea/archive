#require 'msn/msn'
require 'core/connector'
require 'core/message'

class MsnConnector < Connector
	API_MAJOR_VERSION = 3
	API_MINOR_VERSION = 1

	INTERFACE_NAME = :msn

	def initialize(name = "msn-#{@@next_id + 1}")
		super name

		@cfg.set('account', 'my@email.com') if @cfg.get('account').nil?
		@cfg.set('password', 'password') if @cfg.get('password').nil?

		@log.info(sym) { '[init]' }
	end

	override
	def main
		@log.info(sym) { "Entering main loop" }

		@state = Interface::STATE_CONNECTING

		@client = MSNConnection.new(@cfg.get('account'), @cfg.get('password'))
	
		@client.signed_in = lambda {
			@state = Interface::STATE_ONLINE
			@log.info(sym) { "Connected as #{@cfg.get('account')}" }

			@client.contactlists["FL"].list.each do |email, contact|
				@log.info(sym) { p email; p contact }
			end
		}

		@client.buddy_update = lambda { |oldcontact, contact|
			@log.info(sym) { "Buddy updated #{oldcontact.name} -> #{contact.name}" }
		}
	
		@client.new_chat_session = lambda {|tag, session|
			@log.info(sym) { "[new session] tag: #{tag}" }

			session.message_received = lambda {|sender, message|
				msg = Message.new
				msg.source = sender.to_s
				msg.source_channel = tag
				msg.source_connector = self
				msg.destination = @cfg.get('account')
				msg.content = message

				@queue.enq msg

				@log.info(sym) { "[incoming message] sender: #{sender}" }
			}

			session.session_started = lambda {
				@log.info(sym) { "[session start]" }
			}

			session.participants_updated = lambda {
				@log.info(sym) { "[update]" }
			}

			session.start
		} 

		@client.start
		sleep
	end

	def send(message)
		if (message.kind_of? Envelope)
			message.messages.each do |msg|
			end
		elsif (message.kind_of? Message)
		end
	end

	def infoline
		"#{@cfg.get('account')}"
	end

end
