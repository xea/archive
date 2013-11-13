module Features
	def self.feature
		:"dynamic features" 
	end

	protected
	def add_feature(feature)
		if (feature.kind_of? Symbol)
			@features.add feature
		end
	end

	protected
	def remove_feature(feature)
		if (feature_kind_of? Symbol)
			@features.delete feature
		end
	end
end
