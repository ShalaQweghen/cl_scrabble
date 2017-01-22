# ========================================
# Methods related to recording extra words
# ========================================
module Scrabble

	# If the number part of the square >= 10, it slices the last two characters, converts it to an integer
	# and increments or decrements them by 1. This moves moves one spot up or down on the board.
	def up_move(square)
		return square[0] + (square.length == 2 ? square[1].to_i.next.to_s : square[1..2].to_i.next.to_s)
	end

	def down_move(square)
		return square[0] + (square.length == 2 ? (square[1].to_i - 1).to_s : (square[1..2].to_i - 1).to_s)
	end

	# Increments or decrements the letter part of the square. This moves one spot left or right on the board.
	def left_move(square)
		return (square[0].ord - 1).chr + (square.length == 2 ? square[1] : square[1..2])
	end

	def right_move(square)
		return square[0].ord.next.chr + (square.length == 2 ? square[1] : square[1..2])
	end

	def up_or_left(square)
		@player.direction == "r" ? up_move(square) : left_move(square)
	end

	def down_or_right(square)
		@player.direction == "r" ? down_move(square) : right_move(square)
	end

	def occupied_up_or_left?(square)
		return ("A".."Z").include?(@board.board[up_or_left(square).to_sym])
	end

	def occupied_down_or_right?(square)
		return ("A".."Z").include?(@board.board[down_or_right(square).to_sym])
	end

	def set_up_or_left_extra_word(square)
		while occupied_up_or_left?(square)
			square = up_or_left(square)
			# If the extra word is towards up or left, the letter is added to the beginning of the extra word array.
			@extra_word.unshift(@board.board[square.to_sym])
			@extra_set.unshift(square)
		end
	end

	def set_down_or_right_extra_word(square)
		while occupied_down_or_right?(square)
			square = down_or_right(square)
			# If the extra word is towards down or right, the letter is added to the end of the extra word array.
			@extra_word.push(@board.board[square.to_sym])
			@extra_set.push(square)
		end
	end

	def set_extra_word(square)
		@extra_set = [].push(square)
		# Finds the letter equivalent of the square in the player's word according to its index in the set.
		@extra_word = [].push(@player.word[@set.index(square)])
		set_up_or_left_extra_word(square)
		set_down_or_right_extra_word(square)
		@word_list << @extra_word.join
	end

	# This is the main method which makes use of the methods above. Apart from returning a boolean, it also constructs
	# the extra word and calculates its points.
	def extra_word?(square)
		# Non-discord list is cloned because it is mutable.
		non_discard_clone = @non_discard.clone
		# Checks if the letters present in the non-discard list and if any squares surrounding the letter is occupied.
		if non_discard_clone.include?(@board.board[square.to_sym]) && (occupied_up_or_left?(square) || occupied_down_or_right?(square))
			# Removes the letter from the non-discard clone so that if there is another same letter in the word, it doesn't get confused.
			non_discard_clone.delete_at(non_discard_clone.index(@board.board[square.to_sym]))
			# It also means that there is a potential extra word.
			return true
		elsif !occupied_up_or_left?(square) && !occupied_down_or_right?(square)
			# If the letter is not in the non-discard list, there shouldn't be any surrounding squares occupied.
			return true
		else
			set_extra_word(square)
			if @dic.include?(@extra_word.join)
				@player.score += calculate_points(@extra_word.join, @extra_set)
				return true
			else
				return false
			end
		end
	end
end
