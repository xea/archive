require 'set'
require 'lib/vocabulary'

# determiner - hatarozo
# adjective - melleknev

	# The quick brown fox jumps over the lazy dog
	# She listens
	# Joe will strike you
	# We are happy
	# Sleep well while I am waiting!
	# Uncle John gave Emma Jules an anal rape
	# I am an internet superhero
	# Adrian cursed their king for mushrooms!
	#
	
class Sentence
	MOOD_DECLARATIVE = :declarative #kijelento
	MOOD_SUBJUNCTIVE = :subjunctive #felteteles
	MOOD_IMPERATIVE = :imperative #felszolito

	CASE_SUBJECTIVE = :subjective #alanyeset
	CASE_OBJECTIVE = :objective #targyeset
	CASE_GENITIVE = :genitive #birtokoseset (szetbontani hatarozoi es fonevire)
	CASE_REFLEXIVE = :reflexive #visszahato

	TENSE_SIMPLE_PRESENT = :present_simple
	TENSE_PRESENT_CONTINUOUS = :present_continuous
	TENSE_PRESENT_PERFECT_CONTINUOUS = :present_perfect_continuous

	TENSE_PRESENT_PERFECT = :past_present_perfect
	TENSE_SIMPLE_PAST = :past_simple
	TENSE_PAST_CONTINUOUS = :past_continuous
	TENSE_PAST_PERFECT = :past_perfect
	TENSE_PAST_PERFECT_CONTINUOUS = :past_perfect_continuous

	TENSE_SIMPLE_FUTURE = :future_simple
	TENSE_FUTURE_CONTINUOUS = :future_continuous
	TENSE_FUTURE_PERFECT = :future_perfect
	TENSE_FUTURE_PERFECT_CONTINUOUS = :future_perfect_continuous

	attr_accessor :mood, :case, :parts, :tense

	def initialize
		@parts = []
	end

	def to_s
		s = ""
		s += "#<#{object_id} Mood: #{mood.to_s} Case: #{self.case.to_s} Tense: #{self.tense.to_s} "
		s += "Subjects: #{@parts.find_all { |part| part.kind_of? Subject}.length} "
		s += "Objects: #{@parts.find_all { |part| part.kind_of? Object}.length} "
		s += ">"
	end

	def self.generate_plan
		p_object_exists = 50
		p_subject_plural = 25 
		p_object_plural = 20
		p_multi_predicates = 5
		c_max_adjectives = 4
		c_max_subject_count = 10
		c_max_object_count = 4
		c_max_predicate_count = 4

		moods = [ Sentence::MOOD_DECLARATIVE, Sentence::MOOD_IMPERATIVE, Sentence::MOOD_SUBJUNCTIVE ]
		cases = [ Sentence::CASE_SUBJECTIVE, Sentence::CASE_OBJECTIVE, Sentence::CASE_GENITIVE, Sentence::CASE_REFLEXIVE ]
		tenses = [ Sentence::TENSE_SIMPLE_PRESENT, Sentence::TENSE_PRESENT_CONTINUOUS, Sentence::TENSE_PRESENT_PERFECT_CONTINUOUS, Sentence::TENSE_PRESENT_PERFECT, Sentence::TENSE_SIMPLE_PAST, Sentence::TENSE_PAST_CONTINUOUS, Sentence::TENSE_PAST_PERFECT, Sentence::TENSE_PAST_PERFECT_CONTINUOUS, Sentence::TENSE_SIMPLE_FUTURE, Sentence::TENSE_FUTURE_CONTINUOUS, Sentence::TENSE_FUTURE_PERFECT, Sentence::TENSE_FUTURE_PERFECT_CONTINUOUS,] 

		sentence = Sentence.new
		sentence.mood = moods[rand(moods.length)]
		sentence.case = cases[rand(cases.length)]
		sentence.tense = tenses[rand(tenses.length)]

		subject_plural = rand(100) < p_subject_plural ? true : false
		object_plural = rand(100) < p_object_plural ? true : false

		subject_count = subject_plural ? rand(c_max_subject_count) + 1 : 1
		object_count = object_plural ? rand(c_max_object_count) : 1
		object_count = rand(100) < p_object_exists ? object_count : 0

		predicate_count = rand(c_max_predicate_count)
		predicate_count = rand(100) < p_multi_predicates ? predicate_count : 1

		(0...subject_count).each do |i|
			s = Subject.new
			s.number = rand(c_max_subject_count)
			s.adjectives = rand(c_max_adjectives)

			sentence.parts << s
		end

		(0...predicate_count).each do |i|
			p = Predicate.new

			sentence.parts << p
		end

		(0...object_count).each do |i|
			o = Object.new
			o.number = rand(c_max_object_count)
			o.adjectives = rand(c_max_adjectives)

			sentence.parts << o
		end

		sentence
	end

end

class Subject
	attr_accessor :number, :adjectives
end

class Predicate
end

class Object
	attr_accessor :number, :adjectives
end

class Language
	def render(sentence)
	end
end

class Hungarian < Language
	def render(sentence)
	end
end

class English < Language
	@@vocabulary = vocabulary 

	def find_labels(*labels)
		list = Set.new
		find_words(*labels).each { |entry| list.merge entry[1] }
		list - labels
	end

	def find_word(*labels)
		word = @@vocabulary.shuffle.find { |entry| 
			labels.all? { |label| 
				if label.kind_of? Array
					(label - entry[1]).length < label.length
				else
					entry[1].member? label 
				end
			}
		}
	end
	
	def find_words(*labels)
		word = @@vocabulary.shuffle.find_all { |entry| 
			labels.all? { |label| 
				if label.kind_of? Array
					(label - entry[1]).length < label.length
				else
					entry[1].member? label 
				end
			}
		}
	end

	def plural(word)
		if word[-1] =~ /[xs]/i
			return "#{word}es"
		else
			return "#{word}s"
		end
	end

	def construct(subject)
		return nil if subject.nil?
		if subject.number > 1
			"#{subject.number} #{plural(find_word(:noun)[0])}"
		elsif subject.number == 1
			find_word(:noun, :personal)[0]
		else
			nil
		end
	end

	def render(sentence)
		words = []
		text = ""
		if sentence.mood = Sentence::MOOD_DECLARATIVE
			if sentence.tense = Sentence::TENSE_SIMPLE_PRESENT
				subjects = sentence.parts.find_all { |p| p.kind_of? Subject }
				objects = sentence.parts.find_all { |p| p.kind_of? Object }
				predicates = sentence.parts.find_all { |p| p.kind_of? Predicate }

				if subjects.length > 1
					p [ subjects[0...-1].collect { |subject| construct subject }.compact.join(', '),construct(subjects[-1]) ].collect { |e| e.to_s.length == 0 ? nil : e }.compact.join(' and ')
				elsif subjects.length == 1
					p construct subjects[0]
				else
				end
			end
		end

		p words.join " "
	end
end

s = Sentence.generate_plan
puts s.to_s

h = Hungarian.new
e = English.new

e.render s
