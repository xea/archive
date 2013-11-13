module Console
	@@command_table += [
		{ command: 'show traces',				method: :con_trace_show,	mode: [ :trace ],	visible: true,
			description: 'Shows traced expressions',
			help: '' },
		{ command: 'trace <expression>',		method: :con_trace_start,	mode: [ :trace ],	visible: true,
			description: 'Begins tracing of the specified expression',
			help: '' },
		{ command: 'untrace <expression>',		method: :con_trace_stop,	mode: [ :trace ],	visible: true,
			description: 'Stops tracing of the specified expression',
			help: '' },
	]

	def con_trace_start(input, args)
		@traced << args[:expression]

		set_trace_func lambda { |event, file, line, oid, binding, cls|
			# event: c-call, c-return, call, return, class, end, line, raise
			if event == "call" and (@traced.member? cls.to_s or @traced.member? oid.to_s or @traced.member? line.to_s or @traced.member? file.to_s)
				printf("%s %s %s %s %s\n", event, file, line, oid, cls) if event == "call" and @traced.member? cls.to_s 
			end
		}
	end

	def con_trace_stop(input, args)
		@traced.delete args[:expression]

		set_trace_func nil if @traced.length == 0
	end

	def con_trace_show(input, args)
		@traced.each do |trace|
			puts trace
		end
	end

end
