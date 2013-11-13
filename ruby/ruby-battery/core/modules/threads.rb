module Threads
	def self.feature
		:"thread management"
	end

	def register_thread(path, thread)
		if (path.to_s =~ /^[a-z0-9_.-]+$/ and thread.kind_of? Thread)
			parts = path.to_s.split('.').collect { |part| part.to_sym }
			
			if parts.length == 0
				@log.error(:core) { "[register thread] invalid path: #{path.to_s}" }
				return nil
			end

			local_hash = @thread_registry

			parts[0...-1].each do |part|
				if local_hash.kind_of? Hash  
					if !local_hash.has_key? part
						local_hash[part] = Hash.new
					end
				else
					@log.error(:core) { "[register thread] path over object: #{path.to_s}" }
					return nil
				end
			
				local_hash = local_hash[part]
			end

			if local_hash.has_key? parts[-1]
				@log.error(:core) { "[register thread] already registered: #{path.to_s}" }
			else
				local_hash[parts[-1]] = thread
				@log.debug(:core) { "[register thread] #{path.to_s}" }
			end
		else
			@log.error(:core) { "[register thread] invalid path: #{path.to_s}" }
		end
	end

	def get_thread(path)
		if (path.to_s =~ /^[a-z0-9_.-]+$/)
			parts = path.to_s.split('.').collect { |part| part.to_sym }
			
			if parts.length == 0
				@log.error(:core) { "[get thread] invalid path: #{path.to_s}" }
				return nil
			end

			local_hash = @thread_registry

			parts[0...-1].each do |part|
				if !local_hash.has_key? part
					@log.error(:core) { "[get thread] not existing path: #{path.to_s}" }
					return nil
				end
			
				local_hash = local_hash[part]
			end

			if local_hash.has_key? parts[-1]
				return local_hash[parts[-1]]
			else
				@log.debug(:core) { "[get thread] missing thread: #{path.to_s}" }
				return nil
			end
		else
			@log.error(:core) { "[get thread] invalid path: #{path.to_s}" }
		end
	end

	def threads(hash = nil, path = nil)
		if path.nil?
			path = ''
		end

		if hash.nil?
			hash = @thread_registry
		end

		list = {}
		hash.keys.each { |key|
			if hash[key].kind_of? Hash
				list.merge! threads(hash[key], "#{path}#{key.to_s}.")
			elsif hash[key].kind_of? Thread
				list["#{path}#{key}"] = hash[key]
			end
		}
		return list
	end

	def unregister_thread(path)
		if (path.to_s =~ /^[a-z0-9_.-]+$/)
			parts = path.to_s.split('.').collect { |part| part.to_sym }

			if parts.length == 0
				@log.error(:core) { "[unregister thread] invalid path: #{path.to_s}" }
				return nil
			end
			
			local_hash = @thread_registry

			parts[0...-1].each do |part|
				if !local_hash.has_key? part
					@log.error(:core) { "[unregister thread] not existing path: #{path.to_s}" }
					return nil
				end
			
				local_hash = local_hash[part]
			end

			if local_hash.has_key? parts[-1]
				local_hash.delete parts[-1]
				@log.debug(:core) { "[unregister thread] #{path.to_s}" }
			else
				@log.error(:core) { "[unregister thread] missing thread: #{path.to_s}" }
			end
		else
			@log.error(:core) { "[unregister thread] invalid path: #{path.to_s}" }
		end
	end

	def close_thread(thread, timeout = nil)
		if (thread.nil?)
			@log.error(:core) { "[close thread] nil thread" }
		end

		thread.raise ShutdownEvent.new

		if (timeout.to_i > 0) 
			begin
				Timeout::timeout(timeout) do |timeout_length|
				end
			rescue Timeout::Error

			end
		else
		end
	end
end
