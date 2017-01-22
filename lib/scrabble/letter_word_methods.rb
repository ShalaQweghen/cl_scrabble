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
		return @set 		# => @set spicifies the list of squares which the letters are on.
	end

	# If the word is horizontal, the letter parts of the squares increase.
	def set_word_range_to_right
		last = (@player.start[0].ord + @player.word.length - 1).chr 		# => last specifies the letter of the square on which the word ends.
		if @player.start.length == 2
			# Letters increases accordingly, the number part stays the same.
			@set = (@player.start[0]..last).map { |l| l + @player.start[1] }
		else
			@set = (@player.start[0]..last).map { |l| l + @player.start[1..2] }
		end
	end

	# If the word is vertical, the number parts of the squares increase.
	def set_word_range_to_down
		if @player.start.length == 2
			# last specifies the number of the square on which the word ends. Because the word goes down, the number decreases.
			# That's why @set is reversed.
			last = @player.start[1].to_i - @player.word.length + 1
			@set = (last..@player.start[1].to_i).map { |n| @player.start[0] + n.to_s }.reverse
		else
			last = @player.start[1..2].to_i - @player.word.length + 1
			@set = (last..@player.start[1..2].to_i).map { |n| @player.start[0] + n.to_s }.reverse
		end
	end

	def set_non_discard
		@set.each_with_index do |square, idx|
			# If a letter present in the word is already on the board, it is added to the non-discard list.
			# So that it is not taken away from the player's rack.
			if @board.board[square.to_sym] == @player.word[idx]
				@non_discard << @player.word[idx]
			end
		end
	end

	# Checks if a letter in the word specified is either on the player's rack or substituted by a blank letter or
	# in the non-discard list.
	def letters_on_rack?
		return @player.word.chars.all? { |letter| @player.letters.include?(letter) || letter == @wild_tile || @non_discard.include?(letter) }
	end

	def discard_used_letters
		if letters_on_rack?
			@player.word.chars.each do |l|
				unless @non_discard.include?(l)
					# If a blank letter is used, it is set back to blank so that it is not mistakenly attempted to be discarded.
					if !@wild_tile.nil? && l == @wild_tile
						l = "@"
						@wild_tile = nil
					end
					@player.letters.delete_at(@player.letters.index(l))
				else
					# If a letter is present in the non-discard list, it is removed from the list so that it doesn't confuse
					# the rest of letter discarding.
					@non_discard.delete_at(@non_discard.index(l))
				end
			end
		else
			raise TypeError		# => This exception is rescued in the main body.
		end
	end

	def place_word
		@set.each_with_index do |square, idx|
			next if @non_discard.include?(@player.word[idx])	# => If a letter is in the non-discard list, it is already on the board.
			@board.board[square.to_sym] = @player.word[idx]
		end
		@word_list << @player.word
	end

	def change_letters
		@player.passed.each do |l|
			@bag.bag << @player.letters.delete_at(@player.letters.index(l))	# => The letters passed are added back to the bag.
		end
	end

	def ask_wild_tile
		@player.output.puts "What letter would you like to replace with the wild tile?:"
		@wild_tile = @player.input.gets.chomp.upcase
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

	# A valid word should be in the dictionary and its surrounding squares should be suitable.
	def valid_word?
		return (@dic.include?(@player.word) && @set.all? { |spot| extra_word?(spot) }) && legal_move?
	end

	def reset_word_list
		@prev_words = @word_list.clone	# => @prev_list is for listing the words in the turn info.
		@word_list = []
	end
end