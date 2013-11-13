module Console
	@@command_table += [
		{ command: 'show statistics',	method: :con_show_statistics,	mode: [ :debug ],	visible: true,
			description: 'Shows system statistics',
			help: '' },
	]

	def con_show_statistics(input, args)
		t = TableG.new
		t.add_row('KEY', 'VALUE')
		t.add_row('-', '-', ).fill

		@stats.sort_by { |key, value| key }.each do |key, value|
			t.add_row(key.to_s.tr('_', ' '), value)	
		end
		
		t.render.total
	end
end

