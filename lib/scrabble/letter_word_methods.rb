# ====================================
# Methods related to words and letters
# ====================================
module Scrabble

	def set_word_range
		if @player.direction == "r"
			set_word_range_to_right
		else
			set_word_range_to_down
		end
		return @set
	end

	def set_word_range_to_right
		last = (@player.start[0].ord + @player.word.length - 1).chr
		if @player.start.length == 2
			@set = (@player.start[0]..last).map { |l| l + @player.start[1] }
		else
			@set = (@player.start[0]..last).map { |l| l + @player.start[1..2] }
		end
	end

	def set_word_range_to_down
		if @player.start.length == 2
			last = @player.start[1].to_i - @player.word.length + 1
			@set = (last..@player.start[1].to_i).map { |n| @player.start[0] + n.to_s }.reverse
		else
			last = @player.start[1..2].to_i - @player.word.length + 1
			@set = (last..@player.start[1..2].to_i).map { |n| @player.start[0] + n.to_s }.reverse
		end
	end

	def set_non_discard
		i = 0
		@set.each do |square|
			if @board.board[square.to_sym] == @player.word[i]
				@non_discard << @player.word[i]
			end
			i += 1
		end
	end

	def letters_on_rack?
		return @player.word.chars.all? { |letter| @player.letters.include?(letter) || letter == @wild_tile || @non_discard.include?(letter) }
	end

	def discard_used_letters
		if letters_on_rack?
			@player.word.chars.each do |l|
				unless @non_discard.include?(l)
					if !@wild_tile.nil? && l == @wild_tile
						l = "@"
						@wild_tile = nil
					end
					@player.letters.delete_at(@player.letters.index(l))
				else
					@non_discard.delete_at(@non_discard.index(l))
				end
			end
		else
			raise TypeError
		end
	end

	def place_word
		i = 0
		@set.each do |square|
			if @non_discard.include?(@player.word[i])
				i += 1
				next
			end
			@board.board[square.to_sym] = @player.word[i]
			i += 1
		end
		@word_list << @player.word
	end

	def change_letters(passed_letters)
		passed_letters.each do |l|
			@bag.bag << @player.letters.delete_at(@player.letters.index(l))
		end
	end

	def ask_wild_tile
		@output.puts "What letter would you like to replace with the wild tile?:"
		@wild_tile = @input.gets.chomp.upcase
	end

	def set_wild_tile
		if @player.word.include?("@")
			ask_wild_tile
			@player.word[@player.word.index("@")] = @wild_tile
		end
	end

	def process_word
		set_word_range
		set_wild_tile
		set_non_discard
	end

	def valid_word?
		return (@dic.include?(@player.word) && @set.all? { |spot| extra_word?(spot) }) && legal_move?
	end

	def reset_word_list
		@prev_words = @word_list.clone
		@word_list = []
	end
end