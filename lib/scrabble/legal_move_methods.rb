# ==============================================
# Methods related to deciding if a move is legal
# ==============================================
module Scrabble

	def legal_move?
		# The first word to be placed on the board should start from h8.
		if @turns == 1 || @board.board.all? { |key, value| !("A".."Z").include?(value) }
			return @set.include?("h8")
		# The words made should be adjacent to other words on the board.
		elsif @set.any? { |square| ("A".."Z").include?(@board.board[up_or_left(square).to_sym]) }
			return true
		elsif @set.any? { |square| ("A".."Z").include?(@board.board[down_or_right(square).to_sym]) }
			return true
		else
			return false
		end
	end
end