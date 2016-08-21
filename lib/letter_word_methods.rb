module LetterWordMethods

	def word_range
		if @player.direction == "right"
			last = (@player.start[0].ord + @player.word.length - 1).chr
			@set = (@player.start[0]..last).map { |l| l + @player.start[1] }
		else
			last = @player.start[1].to_i - @player.word.length + 1
			@set = (last..@player.start[1].to_i).map { |n| @player.start[0] + n.to_s }.reverse
		end
		return @set
	end

	def discard_used_letters
		@player.word.chars.each do |l|
			unless @non_discard.include?(l)
				@player.letters.delete_at(@player.letters.index(l))
			else
				@non_discard.delete_at(@non_discard.index(l))
			end
		end
	end

	def place_word
		i = 0
		@set.each do |square|
			if @board.board[square.to_sym] == @player.word[i]
				@non_discard << @player.word[i]
				i += 1
				next
			end
			@board.board[square.to_sym] = @player.word[i]
			i += 1
		end
	end
end