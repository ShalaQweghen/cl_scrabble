module ExtraWordMethods

	def up_move(move)
		move = move[0] + (move.length == 2 ? move[1].to_i.next.to_s : move[1..2].to_i.next.to_s)
	end

	def down_move(move)
		move = move[0] + (move.length == 2 ? (move[1].to_i - 1).to_s : (move[1..2].to_i - 1).to_s)
	end

	def left_move(move)
		move = (move[0].ord - 1).chr + (move.length == 2 ? move[1] : move[1..2])
	end

	def right_move(move)
		move = move[0].ord.next.chr + (move.length == 2 ? move[1] : move[1..2])
	end

	def up_or_left(move)
		@player.direction == "right" ? up_move(move) : left_move(move)
	end

	def down_or_right(move)
		@player.direction == "right" ? down_move(move) : right_move(move)
	end

	def occupied_up_or_left?(spot)
		("A".."Z").include?(@board.board[up_or_left(spot).to_sym])
	end

	def occupied_down_or_right?(spot)
		("A".."Z").include?(@board.board[down_or_right(spot).to_sym])
	end

	def set_up_or_left_extra_word(spot)
		cloned_spot = spot.clone
		if occupied_up_or_left?(cloned_spot)
			while occupied_up_or_left?(cloned_spot)
				cloned_spot = up_or_left(cloned_spot)
				@extra_word.unshift(@board.board[cloned_spot.to_sym])
				@extra_set.unshift(cloned_spot)
			end
		end
	end

	def set_down_or_right_extra_word(spot)
		cloned_spot = spot.clone
		if occupied_down_or_right?(cloned_spot)
			while occupied_down_or_right?(cloned_spot)
				cloned_spot = down_or_right(cloned_spot)
				@extra_word.push(@board.board[cloned_spot.to_sym])
				@extra_set.push(spot)
			end
		end
	end

	def set_extra_word(spot)
		@extra_set = [].push(spot)
		@extra_word = [].push(@player.word[@set.index(spot)])
		set_up_or_left_extra_word(spot)
		set_down_or_right_extra_word(spot)
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
