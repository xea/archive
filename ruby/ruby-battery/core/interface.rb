# Interfaces are endpoints for the communication network.
# Every kind of interface implements it's own way of communication
# with other (network) objects. 

class Interface
	STATE_OFFLINE		= :offline
	STATE_ONLINE		= :online
	STATE_SUSPENDED		= :suspended
	STATE_CONNECTING	= :connecting

	API_MAJOR_VERSION	= 0
	API_MINOR_VERSION	= 0

	INTERFACE_NAME		= :generic

	def initialize
		@state = STATE_OFFLINE
	end

	# Attempts to connect to the defined endpoint.
	#
	# If connecting was successful, @state must be set to STATE_ONLINE and true
	# is returned.
	# Otherwise @state must be set to STATE_OFFLINE and false must be
	# returned.

	def connect
		@state = STATE_ONLINE
		return true
	end

	# Suspends the interface if it was previously connected.

	def suspend
		@state = STATE_SUSPENDED
	end

	# Attempts to resume the suspended interface to running state.
	# If the connection was unintentionally interrupted then reestablishing it
	# is recommended.
	#
	# After successful resume the state must be set to STATE_ONLINE

	def resume
		@state = STATE_ONLINE
	end

	# Disconnects the current interface from it's endpoint. No further data
	# traffic is allowed and queued data should be flushed.
	#
	# If the connector needs a specific amount of time to finish disconnecting
	# then it must return the needed amount in seconds. However in 15 seconds it
	# gets interrupted anyway.

	def disconnect
		@state = STATE_OFFLINE
		return 0
	end
end
