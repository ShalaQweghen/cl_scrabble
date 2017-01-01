# ========================================
# Methods related to recording extra words
# ========================================
module Scrabble

	def up_move(move)
		return move[0] + (move.length == 2 ? move[1].to_i.next.to_s : move[1..2].to_i.next.to_s)
	end

	def down_move(move)
		return move[0] + (move.length == 2 ? (move[1].to_i - 1).to_s : (move[1..2].to_i - 1).to_s)
	end

	def left_move(move)
		return (move[0].ord - 1).chr + (move.length == 2 ? move[1] : move[1..2])
	end

	def right_move(move)
		return move[0].ord.next.chr + (move.length == 2 ? move[1] : move[1..2])
	end

	def up_or_left(move)
		@player.direction == "r" ? up_move(move) : left_move(move)
	end

	def down_or_right(move)
		@player.direction == "r" ? down_move(move) : right_move(move)
	end

	def occupied_up_or_left?(spot)
		return ("A".."Z").include?(@board.board[up_or_left(spot).to_sym])
	end

	def occupied_down_or_right?(spot)
		return ("A".."Z").include?(@board.board[down_or_right(spot).to_sym])
	end

	def set_up_or_left_extra_word(spot)
		while occupied_up_or_left?(spot)
			spot = up_or_left(spot)
			@extra_word.unshift(@board.board[spot.to_sym])
			@extra_set.unshift(spot)
		end
	end

	def set_down_or_right_extra_word(spot)
		while occupied_down_or_right?(spot)
			spot = down_or_right(spot)
			@extra_word.push(@board.board[spot.to_sym])
			@extra_set.push(spot)
		end
	end

	def set_extra_word(spot)
		@extra_set = [].push(spot)
		@extra_word = [].push(@player.word[@set.index(spot)])
		set_up_or_left_extra_word(spot)
		set_down_or_right_extra_word(spot)
		@word_list << @extra_word.join
	end

	def extra_word?(spot)
		non_discard_clone = @non_discard.clone
		if non_discard_clone.include?(@board.board[spot.to_sym]) && (occupied_up_or_left?(spot) || occupied_down_or_right?(spot))
			non_discard_clone.delete_at(non_discard_clone.index(@board.board[spot.to_sym]))
			return true
		elsif !occupied_up_or_left?(spot) && !occupied_down_or_right?(spot)
			return true
		else
			set_extra_word(spot)
			if @dic.include?(@extra_word.join)
				@player.score += calculate_points(@extra_word.join, @extra_set)
				return true
			else
				return false
			end
		end
	end
end
