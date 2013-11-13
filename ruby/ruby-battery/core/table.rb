
class Table
	IDENT_LEFT = '-'

	IDENT_RIGHT = ''

	attr_accessor :padding, :show_total

	def initialize(*fields)
		@column_count = fields.length
		@column_width = Array.new(@column_count, 0)
		@column_types = Array.new(@column_count, 's')
		@column_ident = Array.new(@column_count, IDENT_LEFT)
		@column_heads = Array.new(@column_count, '')
		@column_opts  = Array.new(@column_count)
		@padding = 0
		@rows = Array.new
		@show_total = false

		(0...@column_count).each do |i|
			if fields[i] =~ /^(-)?([0-9.]+)?([\w%$!]+)$/
				if '-' == $1
					@column_ident[i] = IDENT_LEFT
				else 
					@column_ident[i] = IDENT_RIGHT
				end

				@column_opts[i] = $2
				@column_types[i] = $3
			end
		end
	end

	def set_header(*fields)
		(0...@column_count).each do |i|
			@column_width[i] = fields[i].length if fields[i].length > @column_width[i]
			@column_heads[i] = fields[i].to_s
		end
	end

	def set_width(i, width)
		@column_width[i] = width
	end

	def add_row(*fields)
		(0...@column_count).each do |i|
			if fields[i].nil?
				@column_types[i] = 's'
				fields[i] = ''
			end

			@column_width[i] = fields[i].to_s.length if fields[i].to_s.length > @column_width[i]
		end

		@rows << fields
	end

	def format(head = false)
		format = ' ' * (2 + @padding)

		(0...@column_count).each do |i|
			format += '%'
			format += @column_ident[i]
			format += @column_width[i].to_s

			if (!@column_opts[i].nil?)
				format += @column_opts[i]
			end

			if head
				format += 's'
			else
				format += @column_types[i]
			end

			format += " "
		end

		format += "\n"

		format
	end

	def print
		print_format = format

		args = [ format(true) ]
		
		(0...@column_count).each do |i|
			args << @column_heads[i].upcase
		end

		printf(*args)

		args = [ format(true) ]

		(0...@column_count).each do |i|
			args << ('-' * @column_width[i].to_i)
		end

		printf(*args)

		@rows.each do |row|
			args = [ print_format ]

			(0...@column_count).each do |i|
				args << row[i]
			end
		
			printf(*args)
		end

		puts
		if @show_total
			puts "#{@rows.length} row(s) listed"
			puts
		end
	end
end

class Field
	attr_accessor :type, :prefix, :postfix, :align, :length, :data

	def initialize(field, type = :string, align = :left, length = -1, prefix = nil, postfix = nil)
		@data = field
		@type = type
		@length = length
		@align = align
		@prefix = prefix
		@postfix = postfix
	end

	def to_s
		format = "%s"
		out_data = @data

		case @type
		when :string
			length = (@length.to_i < 0) ? "" : @length.to_i.to_s
			align = (@align == :left) ? "-" : ""
			format = "%#{align}#{length}s"
		when :float
			length = (@length.to_f < 0) ? "" : @length.to_f.to_s
			align = (@align == :left) ? "-" : ""
			format = "%#{align}#{length}f"
		when :integer
			length = (@length.to_i < 0) ? "" : @length.to_i.to_s
			align = (@align == :left) ? "-" : ""
			format = "%#{align}#{length}d"
			out_data = @data.to_i
		when :hex
			length = (@length.to_i < 0) ? "" : @length.to_i.to_s
			align = (@align == :left) ? "-" : ""
			out_data = @data.to_i
			format = "%#{align}#{length}s"
		end
			
		sprintf(format, out_data.to_s)
	end

	def fmt_align
		case @align
		when :left
			return "-"
		else
			return ""
		end
	end

	def fmt_type
		case @type
		when :string
			return "s"
		when :float
			return "f"
		when :integer
			return "d"
		when :hex
			return "x"
		else
			return "s"
		end
	end
end

class Row
	attr_reader :fields

	def initialize(*fields)
		@fields = []

		fields.each do |field|
			@fields << Field.new(field, :string, :right)
		end
	end

	def align(*directions)
		directions.each_with_index do |direction, i|
			@fields[i].align = direction if direction.kind_of? Symbol
		end

		return self
	end

	def type(*types)
		if (types.length > 0)
			types.each_with_index do |type, i|
				@fields[i].type = type unless @fields[i].nil?
			end
		else
			@fields.each do |field|
				case field.data.class.to_s.to_sym
				when :Integer
					field.type = :integer
				when :String
					field.type = :string
				when :Float 
					field.type = :float
				else
					field.type = :string
				end
			end
		end

		return self
	end

	def prefix(*prefixes)
		prefixes.each_with_index do |prefix, i|
			@fields[i].prefix = prefix
		end

		return self
	end

	def suffix(*suffixes)
		postfix(*suffixes)
	end

	def postfix(*postfixes)
		postfixes.each_with_index do |postfix, i|
			@fields[i].postfix = postfix
		end

		return self
	end

	def length(*lengths)
		lengths.each_with_index do |length, i|
			@fields[i].length = length unless length.nil?
		end
	end

	def [](key)
		@fields[key.to_i]
	end

	def fill
		@fields.each do |field|
			field.type = :fill
		end
	end
end

class TableG

	def initialize(*headers)
		@rows = []
		@default_types = headers
		@max_fields = headers.length
		@padding = 2
	end

	def add_row(*fields)
		row = Row.new(*fields)
		row.type(*@default_types)

		@max_fields = fields.length if fields.length > @max_fields

		@rows << row

		return row
	end

	def padding(padding)
		@padding = padding.to_i

		return self
	end

	def dump
		data = {}
		data[:data] = []
		data[:maxwidth] = Array.new(@max_fields, 0)

		lrows = data[:data]

		@rows.each do |row|
			lf = []

			row.fields.each_with_index do |field, i|
				cont = field.to_s

				cum_length = cont.length + field.prefix.to_s.length + field.postfix.to_s.length

				data[:maxwidth][i] = cum_length if data[:maxwidth][i] < cum_length

				lf << field
			end

			lrows << lf
		end

		return data 
	end

	def render
		data = dump

		d = data[:data]

		d.each do |row|
			print " " * @padding
			row.each_with_index do |field, i|

				if field.type == :fill
					print field.to_s * data[:maxwidth][i] 
				else
					spaces = data[:maxwidth][i] - field.to_s.length - field.prefix.to_s.length - field.postfix.to_s.length

					if field.align == :left
						print field.prefix.to_s
						print field.to_s
						print field.postfix.to_s
						print " " * spaces
					elsif field.align == :right
						print " " * spaces
						print field.prefix.to_s
						print field.to_s
						print field.postfix.to_s
					end

				end
				
				print " " * @padding
			end
			puts
		end

		return self
	end

	def total(fmt = "%d rows total")
		puts
		printf((" " * @padding) + fmt, @rows.length)
		puts
	end
end

=begin
t = TableG.new(:string, :string, :string).padding(2)
t.add_row('ID', 'name', '%')
t.add_row('-', '-', '-').types(:fill, :fill, :fill)
t.add_row(1, 'blabla', 94.4444).types(:hex, :string, :integer).prefix('-', '-', '-').postfix('!', nil, '%')
t.add_row(33121, 'basdfasdflabla', 94.4444).types(:integer, :integer, :hex).postfix('-', '%', '=')
t.add_row(nil, 'ahah', 1).align(:left, :right, :left).postfix(nil, nil, '$')

t.render.total

=end
