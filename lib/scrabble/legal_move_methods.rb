# ==============================================
# Methods related to deciding if a move is legal
# ==============================================
module Scrabble

	def legal_move?
		if @turns == 1
			return @set.include?("h8")
		elsif @set.any? { |square| ("A".."Z").include?(@board.board[up_or_left(square).to_sym]) }
			return true
		elsif @set.any? { |square| ("A".."Z").include?(@board.board[down_or_right(square).to_sym]) }
			return true
		else
			return false
		end
	end
end