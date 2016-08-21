module Technical
	
	# Returns the point value of letters.
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
		else
			return 0
		end
	end

	# Gives the sum of the point values of all the letters in a word.
	def calculate_points(word)
		word.chars.inject(0) { |sum, letter| sum + point(letter) }
	end
end

# bag = %w[a b c d e f g h i j k l m n o p r s s s s t t]