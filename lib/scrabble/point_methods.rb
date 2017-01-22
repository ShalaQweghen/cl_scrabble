# =====================================
# Methods related to calculating points
# =====================================
module Scrabble

	def set_point(letter)
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

	def calculate_points(word=@player.word, set=@set)
		bonus = calculate_bonus(set)
		i = 0
		@sum = 0
		word.chars.map do |letter|
			# Sets the blank letter used in a word back to blank so that it doesn't get the substituted letter point by mistake.
			if !@wild_tile.nil? && letter == @wild_tile
				letter = "@"
			end
			# Checks if there are any bonuses recieved by the letter and assigns point accordingly.
			unless bonus[:letter][set[i]].nil?
				@sum += (set_point(letter) * bonus[:letter][set[i]])
			else
				@sum += set_point(letter)
			end
			i += 1
		end
		# Applies word bonuses if any.
		unless bonus[:word].values.nil?
			bonus[:word].values.each { |b| @sum *= b }
		end
		@turns == 1 ? @sum *= 2 : @sum		# => The first word placed on the board gets double word score.
	end

	def calculate_bonus(set)
		bonus = { word: {}, letter: {} }
		set.each do |square|
			case @board.board[square.to_sym]
			when "2w" then bonus[:word][square] = 2
			when "3w" then bonus[:word][square] = 3
			when "2l" then bonus[:letter][square] = 2
			when "3l" then bonus[:letter][square] = 3
			end
		end
		return bonus
	end

	def give_points
		calculate_points
		@sum += 60 if @player.letters.empty? && @player.word.length == 7	# => A word made with all the letters on the rack recieves a bonus.
		@player.score += @sum unless @sum.nil?
	end
end