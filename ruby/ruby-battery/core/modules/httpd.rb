require 'webrick'
require 'erb'

include WEBrick

module Httpd

	def self.feature
		:"web UI"
	end

	def init_module
		add_hook 'pre_start', 'httpd', lambda {
			thread = Thread.new do 
				start_httpd
				unregister_thread('core.httpd')
			end

			register_thread('core.httpd', thread)
		}

		add_hook 'shutdown', 'httpd', lambda {
			@http_server.shutdown
		}
	end

	def start_httpd
		access_log = [
          [ File.open('log/access_log', 'a'), AccessLog::COMMON_LOG_FORMAT ]
        ] 

		@http_server = HTTPServer.new( :Port => 2090, :AccessLog => access_log )
		@http_server.mount('/', StaticServlet, get_binding)
		@http_server.mount('/status', StatusServlet, get_binding)
		@http_server.mount('/static', StaticServlet, get_binding)
		@http_server.mount('/ajax', AjaxServlet, get_binding)
		@http_server.logger.level = Logger::WARN
		@http_server.start
	end
end

class StaticServlet < HTTPServlet::AbstractServlet
	def do_GET(request, response)
		path = request.path.gsub(/^\/(static)?/, '')

		response.body = File.open('static/' + path, 'r').read
	end
end

class StatusServlet < HTTPServlet::AbstractServlet
	def initialize(server, *options)
		super server, options

		@binding = options[0]
	end

	# path: /status/info   path_info: /info
	def do_GET(request, response)
		file = "status"
		
		if request.path_info =~ /^[\/]?$/
			file = "status"
		elsif request.path_info =~ /^\/msg\/(\d+)[\/]?$/
			file = "message"
		elsif request.path_info =~ /^\/inbound[\/]?$/
			file = "inbound"
		elsif request.path_info =~ /^\/recycle[\/]?$/
			file = "recycle"
		elsif request.path_info =~ /^\/connector\/([^\/]+)\/start$/
			file = "status"
			@binding.eval("start_connector('#{$1}')")

			response.status = 302
			response['Location'] = '/status'
		elsif request.path_info =~ /^\/connector\/([^\/]+)\/stop$/
			@binding.eval("stop_connector('#{$1}')")
			
			response.status = 302
			response['Location'] = '/status'
		elsif request.path_info =~ /^\/channel\/([^\/]+)\/enable$/
			channel, connector = $1.split('@')
			@binding.eval("execute_command(lookup_command('/priv/config-term/connector #{connector}/enable channel #{channel}'))")

			response.status = 302
			response['Location'] = '/status'
		elsif request.path_info =~ /^\/channel\/([^\/]+)\/disable$/
			channel, connector = $1.split('@')
			@binding.eval("execute_command(lookup_command('/priv/config-term/connector #{connector}/disable channel #{channel}'))")
			response.status = 302
			response['Location'] = '/status'
		elsif request.path_info =~ /^\/channel\/([^\/]+)\/synchronize$/
			channel, connector = $1.split('@')
			cmd = "execute_command(lookup_command('/priv/config-term/connector #{connector}/synchronize'))"
			@binding.eval(cmd)
			
			response.status = 302
			response['Location'] = '/status'
		elsif request.path_info =~ /^\/route\/([^\/]+)\/enable$/
			route = $1
			cmd = "execute_command(lookup_command('/priv/config-term/router/route-edit #{route}/enable'))"
			@binding.eval(cmd)
			
			response.status = 302
			response['Location'] = '/status'
		elsif request.path_info =~ /^\/route\/([^\/]+)\/disable$/
			route = $1
			cmd = "execute_command(lookup_command('/priv/config-term/router/route-edit #{route}/disable'))"
			@binding.eval(cmd)
			
			response.status = 302
			response['Location'] = '/status'
		end

		response['Content-Type'] = "text/html"

		template = File.new("templates/#{file}.rhtml", 'r').read

		response.body = ERB.new(template).result(@binding)
	end

end

class AjaxServlet < HTTPServlet::AbstractServlet
	def initialize(server, *options)
		super server, options

		@binding = options[0]
	end

	# path: /status/info   path_info: /info
	def do_GET(request, response)
		response['Content-Type'] = "text/html"

		file = "ajax"

		template = File.new("templates/#{file}.rhtml", 'r').read

		response.body = ERB.new(template).result(@binding)
	end
end
