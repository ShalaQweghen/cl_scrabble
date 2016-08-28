module LegalMoveMethods

	def first_move?
		return true if @board.board.all? { |k,v| !("A".."Z").include?(v) }
	end

	def legal_move?
		if first_move?
			return true if @set.include?("h8")
		elsif @set.any? { |square| ("A".."Z").include?(@board.board[up_or_left(square).to_sym]) }
			return true
		elsif @set.any? { |square| ("A".."Z").include?(@board.board[down_or_right(square).to_sym]) }
			return true
		else
			return false
		end
	end
end