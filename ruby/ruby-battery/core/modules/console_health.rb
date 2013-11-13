module Console
	@@command_table += [
		{ command: 'show health',	method: :con_show_health,	mode: [ :debug ],	visible: true,
			description: 'Shows system health table',
			help: '' },
		{ command: 'show exceptions',	method: :con_show_exceptions,	mode: [ :debug ],	visible: true,
			description: 'Shows a list of registered run-time exceptions',
			help: '' },
	]

	def con_show_health(input, args)
		h = scan_health

		t = TableG.new
		t.add_row('PROBE', 'SUCCESSES', 'FAILURES', '%', 'ERRORS')
		t.add_row('-', '-', '-', '-', '-').fill

		h.each do |probe, test|
			p = 100.0
			p = test.successes * 100.0 / (test.successes + test.failures) unless test.successes + test.failures == 0.0

			t.add_row(probe.capitalize, test.successes, test.failures, p, '')
				.suffix(nil, nil, nil, '%', nil)
				.length(nil, nil, nil, 3.2, nil)
			
			if (test.failures > 0)
				test.errors.each do |error|
					t.add_row(nil, nil, nil, nil, error).align(:right, :right, :right, :right, :left)
				end
			end
		end

		total_successes, total_failures, p = global_health

		t.add_row('-', '-', '-', '-', nil).fill
		t.add_row('TOTAL', total_successes, total_failures, p, nil)
			.postfix(nil, nil, nil, '%', nil)
			.length(nil, nil, nil, 3.2, nil)

		t.render
	end

	def con_show_exceptions(input, args)
		t = TableG.new
		t.add_row('OID', 'TIME', 'CLASS', 'MESSAGE', 'LOCATION')
		t.add_row('-', '-', '-', '-', '-').fill

		@exceptions.each do |exception|
			t.add_row(exception.object_id, exception.date.to_s, exception.class.to_s, exception.message, exception.backtrace[0])
		end

		t.add_row
		t.render
	end
end

