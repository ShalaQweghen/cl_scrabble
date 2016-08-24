module ExtraWord

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

	def extra_word(spot)
		if @non_discard.include?(@board.board[spot.to_sym]) && (("A".."Z").include?(@board.board[up_or_left(spot).to_sym]) || ("A".."Z").include?(@board.board[down_or_right(spot).to_sym]))
			@non_discard.delete_at(@non_discard.index(@board.board[spot.to_sym]))
			return true
		elsif !("A".."Z").include?(@board.board[up_or_left(spot).to_sym]) && !("A".."Z").include?(@board.board[down_or_right(spot).to_sym])
			return true
		else
			cloned_spot = spot.clone
			set = [].push(spot)
			word = [].push(@player.word[@set.index(spot)])
			if ("A".."Z").include?(@board.board[up_or_left(spot).to_sym])
				while ("A".."Z").include?(@board.board[up_or_left(cloned_spot).to_sym])
					cloned_spot = up_or_left(cloned_spot)
					word.unshift(@board.board[cloned_spot.to_sym])
					set.unshift(cloned_spot)
				end
			end
			if ("A".."Z").include?(@board.board[down_or_right(spot).to_sym])
				while ("A".."Z").include?(@board.board[down_or_right(spot).to_sym])
					spot = down_or_right(spot)
					word.push(@board.board[spot.to_sym])
					set.push(spot)
				end
			end
			if @dic.include?(word.join)
				@player.score += calculate_points(word.join, set)
				return true
			else
				return false
			end
		end
	end
end
