require 'time'
require 'timeout'
require 'core/message'

module Services

	def self.feature
		:"message queues"
	end

	def init_module
		# The message pool is an array that holds every message
		@message_pool = Array.new

		register_hook('pre_start_service')
		register_hook('post_start_service')
		register_hook('pre_stop_service')
		register_hook('post_stop_service')

		add_hook 'post_init', 'services', lambda { 
			Thread.new do
				register_thread('core.boot', Thread.current)

				[ :router, :collector, :delivery ].each do |service|
					start_service(service)
				end

				unregister_thread('core.boot')
			end
		}
		add_hook 'pre_stop', 'services', lambda { 
			[ :router, :collector, :delivery ].each do |service|
				stop_service(service)
			end
		}
	end

	def start_service(service)
		if (!service.kind_of? Symbol)
			@log.error(:core) { "[start service] invalid service: #{service.to_s}" }
			return false
		end

		service_thread = nil

		if (service == :router)
			call_hook('pre_start_service', service)

			service_thread = Thread.new do
				router_process
			end
		elsif (service == :collector)
			call_hook('pre_start_service', service)

			service_thread = Thread.new do
				collector_process
			end
		elsif (service == :delivery)
			call_hook('pre_start_service', service)

			service_thread = Thread.new do
				delivery_process
			end
		end
		
		if (service_thread.nil?)
			@log.error(:core) { "[start service] no such service exist: #{service.to_s}" }
			return false
		end

		register_thread("core.#{service.to_s}", service_thread)

		@log.info(:core) { "[start service] #{service.to_s}" }

		call_hook('post_start_service', service)
	end

	def stop_service(service)
		if (!service.kind_of? Symbol)
			@log.error(:core) { "[stop service] invalid service: #{service.to_s}" }
			return false
		end

		service_thread = get_thread("core.#{service.to_s}")

		if (service_thread.nil?)
			@log.error(:core) { "[stop service] not started: #{service.to_s}" }
			return false
		end

		call_hook('pre_stop_service')
	
		close_thread(service_thread, 10)
		
		call_hook('post_stop_service')

		unregister_thread("core.#{service.to_s}")
	end

	# The control process manages the incoming queue which holds every message
	# that has to be routed somewhere. When a message arrives the control process
	# prepares it for routing and finally passes it to the router

	private
	def router_process
		begin
			@log.info(:router) { '[start router]' }

			while true
				message = @inbound_queue.deq
				message.assert_kind Message
				message.append_log(:control) { 'Accepted from inbound' }

				@message_pool << message
				@configuration.increase('global.stats.incoming_messages')
				call_hook('incoming_message', message)

				call_hook('pre_route', message)
				route message
				call_hook('post_route', message)
			end
		rescue ShutdownEvent => e
			@log.info(:router) { '[stop service] router' }
		rescue Exception => e
			@log.error(:router) { "[stop service] router: unhandled exception: #{e.message}" }
			Util.handle_exception(e)
		end
	end

	private
	def collector_process
		begin
			@log.info(:collector) { '[start service] collector' }
			
			now = Time.now.to_i

			@configuration.set('core.scheduler.last_low', now)
			@configuration.set('core.scheduler.last_normal', now)
			@configuration.set('core.scheduler.last_high', now)

			while true
				# eg. 10000
				now = Time.now.to_i

				sd = {
					Message::PRIORITY_LOW => 
						[ @configuration.get('core.scheduler.last_low'), @configuration.get('core.scheduler.sleep_low'), 'low' ],
					Message::PRIORITY_NORMAL => 
						[ @configuration.get('core.scheduler.last_normal'), @configuration.get('core.scheduler.sleep_normal'), 'normal' ],
					Message::PRIORITY_HIGH => 
						[ @configuration.get('core.scheduler.last_high'), @configuration.get('core.scheduler.sleep_high'), 'high' ]
				}

				next_sleep = sd.collect { |pri, data| data[0].to_i + data[1].to_i - now }.min.to_i

				sleep next_sleep if next_sleep > 0

				now = Time.now.to_i

				envelopes = Hash.new

				sd.each do |priority, data|
					if (data[0].to_i + data[1].to_i <= now)
						@waiting_queues[priority.to_i].each do |target, list|
							envelopes[target] = envelopes[target].to_a + list

							list.clear
						end

						@waiting_queues[priority.to_i].clear
						@configuration.set("core.scheduler.last_#{data[2]}", now)
					end
				end

				if (envelopes.length > 0)
					envelopes.each do |target, list|
						envelope = Envelope.new(target, list)

						envelope.destination = target.to_sym

						call_hook('create_envelope', envelope)

						list.each do |message|
							message.append_log(:collector) { "Moved into envelope #{envelope.id} heading to #{target.to_s}" }
						end
							
						envelope.destination.assert_not_nil
						@outbound_queue.enq envelope
					end
				end
			end
		rescue ShutdownEvent => e
			@log.info(:collector) { '[stop service] collector' }
		rescue Exception => e
			Util.handle_exception(e)
			@log.error(:collector) { "[stop service] router: unhandled exception: #{e.message}" }
		end
	end

	# Sends out the envelopes in the outbound queue to their respective 
	# destinations.

	private
	def delivery_process
		begin
			@log.info(:delivery) { '[start service]' }

			while true
				envelope = @outbound_queue.deq

				@log.debug(:delivery) { "[pick envelope] id: #{envelope.id}" }

				destination_connector = nil

				if (!envelope.destination.nil?)
					if (envelope.destination.kind_of? Connector)
						destination_connector = envelope.destination
					elsif (@connectors.has_key? envelope.destination.to_sym)
						destination_connector = @connectors[envelope.destination.to_sym]
					end
				end

				if (destination_connector.nil?)
					envelope.messages.each do |message|
						@undelivered_messages << message
						message.append_log(:delivery) { "Could not deliver message for no destination could be found" }
						@log.error(:delivery) { "[deliver envelope] destination connector is null for message ##{message.id}" }
					end
					call_hook('delivery_failed', envelope)
				else
					if (destination_connector.state == Interface::STATE_ONLINE)
						destination_connector.send envelope
					
						envelope.messages.each do |message|
							message.append_log(:delivery) { "Sent out" }
						end

						@log.debug(:delivery) { "[deliver envelope] id: ##{envelope.id} on #{destination_connector.name}" }

						call_hook('delivery_done', envelope)
					else
						destination_connector.inqueue.enq envelope
						
						envelope.messages.each do |message|
							message.append_log(:delivery) { "Queued out" }
						end

						@log.debug(:delivery) { "[enqueue envelope] id: ##{envelope.id}" }
					end
				end
			end
		rescue ShutdownEvent => e
			@log.info(:delivery) { '[stop service]' }
		rescue Exception => e
			Util.handle_exception(e)
			@log.error(:delivery) { "[stop service] unhandled exception: #{e.message}" }
		end
	end
end
