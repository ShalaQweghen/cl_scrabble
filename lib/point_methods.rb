module PointMethods

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

	def calculate_points(word=@player.word, set=@set)
		bonus = calculate_bonus(set)
		i = 0
		@sum = 0
		word.chars.map do |letter|
			unless bonus[:letter][set[i].to_sym].nil?
				@sum += (point(letter) * bonus[:letter][set[i].to_sym])
			else
				@sum += point(letter)
			end
			i += 1
		end
		unless bonus[:word].values.nil?
			bonus[:word].values.each do |b|
				@sum *= b
			end
		end
		@sum
	end

	def calculate_bonus(set)
		bonus = { word: {}, letter: {} }
		set.each do |square|
			case @board.board[square.to_sym]
			when "2w" then bonus[:word][square.to_sym] = 2
			when "3w" then bonus[:word][square.to_sym] = 3
			when "2l" then bonus[:letter][square.to_sym] = 2
			when "3l" then bonus[:letter][square.to_sym] = 3
			end
		end
		return bonus
	end
end