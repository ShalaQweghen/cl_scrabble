module Technical

	def point(letter)
		if %w[L S U N R T O A I E].include?(letter)
			return 1
		elsif %w[G D].include?(letter)
			return 2
		elsif %w[B C M P].include?(letter)
			return 3
		elsif %w[F H V W Y].include?(letter)
			return 4
		elsif %w[K].include?(letter)
			return 5
		elsif %w[J X].include?(letter)
			return 8
		elsif %w[Q Z].include?(letter)
			return 10
		end
	end

	def calculate_points(word)
		word.chars.inject(0) {|v, p| v + point(p)}
	end
end
			
			