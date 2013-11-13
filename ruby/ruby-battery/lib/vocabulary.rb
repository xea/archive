def vocabulary
		# noun / pronoun
		#	personal
		#		singular / plural
		#		first / second / third
		#		subjective / objective / genitive
		#	simple / compound
		#	singular / plural
		#	countable / uncountable
		#	
		# adjective
		#
		# misc
		#	color
		#	derivational_prefix (arch-, dis-)
		#	derivational_suffix (-dom, -ment, -ary, -an, -ism)
	return [
		[ "I",		[ :pronoun, :personal, :singular, :first, :subjective ]],
		[ "me",		[ :pronoun, :personal, :singular, :first, :objective ]],
		[ "my",		[ :pronoun, :personal, :singular, :first, :genitive ]],
		[ "you",	[ :pronoun, :personal, :singular, :plural, :second, :subjective, :objective ]],
		[ "your",	[ :pronoun, :personal, :singular, :plural, :second, :genitive ]],
		[ "he",		[ :pronoun, :personal, :singular, :third, :subjective ]], 
		[ "him",	[ :pronoun, :personal, :singular, :third, :objective ]], 
		[ "his",	[ :pronoun, :personal, :singular, :third, :genitive ]], 
		[ "we",		[ :pronoun, :personal, :plural, :first, :subjective ]],
		[ "us",		[ :pronoun, :personal, :plural, :first, :objective ]],
		[ "our",	[ :pronoun, :personal, :plural, :first, :genitive ]],
		[ "they",	[ :pronoun, :personal, :plural, :second, :subjective ]],
		[ "them",	[ :pronoun, :personal, :plural, :second, :objective ]],
		[ "their",	[ :pronoun, :personal, :plural, :second, :genitive ]],
		
		[ "Alex",	[ :noun, :personal, :single, :male ]],
		[ "Peter",	[ :noun, :personal, :single, :male ]],

		[ "beaver",	[ :noun, :single, :neutral, :animal ]],
		[ "cow",	[ :noun, :single, :neutral, :animal ]],
		[ "dog",	[ :noun, :single, :neutral, :animal ]],

	]
end
