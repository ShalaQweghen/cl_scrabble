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

	# Gets a random letter from the letter list.
	def pick_from(bag)
		bag.shuffle!.pop
	end

	# Add specific amount of letter to the player's letters. Default values are for the first
	# draw at the beginning of the game.
	def draw_letters(bag, amount=7, letters=[])
		amount.times { letters << pick_from(bag) }
		return letters
	end
end

# bag = %w[a b c d e f g h i j k l m n o p r s s s s t t]