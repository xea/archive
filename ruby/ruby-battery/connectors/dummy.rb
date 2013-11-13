require 'core/util'
require 'core/connector'
require 'core/message'

class DummyConnector < Connector
	API_MAJOR_VERSION = 3
	API_MINOR_VERSION = 1

	INTERFACE_NAME = :dummy
	
	def initialize(name = "dummy-#{@@next_id + 1}")
		super name

		@sleep_time = 5
	end

	override
	def main
		begin
			@run = true
			@state = Interface::STATE_ONLINE

			current_sleep = 0

			while @run
				@sleep_time = @cfg.get('sleep_time').to_i.abs

				if @sleep_time < 5
					@sleep_time = 5
				end

				sleep 1
				
				current_sleep += 1

				if (current_sleep >= @sleep_time)
					current_sleep = 0

					message = Message.new
					message.source_connector = self
					message.source_channel = "channel #{rand(10).to_s}"
					message.source = "source #{rand(10).to_s}"
					message.destination = "destination #{rand(10).to_s}"
					message.priority = rand(3) + 1
					
					message.content = generate_content

					@queue.enq message

					@log.info(sym) { "[produce message] #{message.id}: #{message.content}" }
				end
			end
		rescue Exception => exception
			p exception
		end
	end

	def generate_content
		words = [ 'I', 'you', 'he', 'she', 'we', 'you', 'they', 'apple', 'longbow', 'horseballs',
			'ate', 'give', 'love', 'sleep', 'George', 'Peter', 'Adrian', 'Jules', 'Anna', 'Katerina',
			'go', 'fight', 'hard', 'soft', 'blue', 'green', 'toad', 'of', 'for', 'from', 'to', 'into', 
			'cat', 'dog', 'carrot', 'mushroom', 'fat', 'ass', 'no', 'harm', 'all', 'none', 'every',
			'single', 'multi', 'internet', 'domain', 'geek', 'worm', 'us', 'me', 'him', 'her', 'them',
			'uncle', 'aunt', 'Emma', 'Chris', 'epic', 'grave', 'rotten', 'balsamed', 'cursed', 'damned',
			'litch', 'prince', 'king', 'duke', 'baron', 'queen', 'princess', 'baroness', 'banana', 'roll',
			'take', 'bow', 'elbow', 'knee', 'fist', 'anal', 'rape', 'first', 'second', 'third', 'fourth',
			'fifth', 'sixth', 'seventh', 'eight', 'nineth', 'tenth', 'row', 'column', 'took', 'cook', 'baked',
			'boiled', 'digged', 'hugged', 'hit', 'pushed', 'superhero', 'court', 'man', 'woman', 'packet',
			'metal', 'wooden', 'red', 'viral', 'fox', 'dog', 'wolf', 'ocelot', 'duck', 'goose', 'mermaid',
			'fluffy', 'bagger 288', 'ruby', 'battery', 'tongue', 'machine', 'painting', 'rolling', 'sitting',
			'calling', 'looking', 'watching', 'pulling', 'farting', 'dark', 'darkest', 'a', 'the', 'an', 
			'coward', 'brave', 'point', 'pointing', 'commanding', 'eerie', 'shout', 'chomp', 'hardened',
			'forth', 'backward', 'upwards', 'downwards', 'light', 'dark', 'shoot', 'shooting', 'star',
			'sloppy', 'wet', 'dry', 'finger', 'head', 'chest', 'pick', 'punches', 'gave', 'gives', 'food',
			'drink', 'envelope', 'bandana', 'sword', 'ring', 'fire', 'ice', 'mighty', 'slave', 'of the', '\'s',
			'and', 'or', 'cow', 'crocodile', 'death', 'life', 'ring', 'god', 'hell', 'heavenly', 'axe', 
			'hammer', 'udder', 'glorious', 'fast', 'slow', 'terminator'
		]
			
		punctuation = [ '! ', '. ', ', ', ': ', '? ', ', ', ', ' ]

		length = rand(30)

		msgparts = []

		(0..length).each do |i|
			msgparts << words[rand(words.length)]

			p = rand(1000)

			if (p < 200)
				msgparts << punctuation[rand(punctuation.length)]
			else
				msgparts << ' '
			end
		end

		return msgparts.join
	end

	def disconnect
		@run = false

		super

		return 1
	end
	
	override
	def send(object)
		if (object.kind_of? Message)
			puts "[send] message #{object.id}" 
		elsif (object.kind_of? Envelope)
			puts "[send] envelope #{object.id}"
		end
	end

	override
	def add_channel(channel)
		super(channel).state = :on
	end
end
