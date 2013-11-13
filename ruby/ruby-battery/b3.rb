#!/usr/bin/ruby -w

$: << './lib'

require 'core/util'
require 'core/core'

begin
	core = Core.get_instance	
	core.start
	core.stop
rescue Exception => exception
	Util.handle_exception(exception)
end

todo = [
	"password save",
	"recycle bin kezeles",
	"pickup dir",
	"online update",
	"statistics save",
	"thread safety",
]

todo.each { |item| puts "TODO: #{item}" }
