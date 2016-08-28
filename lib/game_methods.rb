module GameMethods

	def welcome
		puts "========================================================"
		puts "Welcome to the Command-line Scrabble!"
		puts "It is a game of making words with the letters you have."
		puts "Of course, the word should be present in the dictionary."
		puts "Before playing, make sure to read README."
		puts "Have fun!"
		puts "========================================================"
	end

	def rescue_interrupt
		print "\nDo you want to save the game?(y/n): "
		response = gets.chomp.downcase
		case response
		when "y" then save
		when "n" then exit_game
		end
	end

	def rescue_type_error
		puts "\n==============================================="
		puts "One of the letters is not present on your rack!"
		puts "==============================================="
	end

	def exit_game
		at_exit do
			puts
			puts "GOODBYE!"
		end
		exit
	end

	def display_letters
		puts
		puts "\u2551 #{@player.letters.join(" - ")} \u2551".center(70)
	end

	def turn
		@turns += 1
	end

	def set_turn_pointer
		if @players == 2
			@player.turn_pointer += 2
		elsif @players == 3
			@player.turn_pointer += 3
		elsif @players == 4
			@player.turn_pointer += 4
		end
	end

	def turn_statement
		puts "\n#{@bold_on}Player:#{@bold_off} #{@player.name}\t\t#{@bold_on}|#{@bold_off}  #{@bold_on}Total Points:#{@bold_off} #{@player.score}"
		puts "#{@bold_on}Letters Left in Bag:#{@bold_off} #{@bag.bag.size}\t#{@bold_on}|#{@bold_off}  #{@bold_on}Word by Prev. Player:#{@bold_off} #{@word_list[0] || 0} for #{@sum || 0} points"
		@sum = 0
	end

	def game_over?
		if @players == 2
			@game_over = true if @pass == 6
		elsif @players == 3
			@game_over = true if @pass == 9
		elsif @players == 4
			@game_over = true if @pass == 12
		end
	end

	def finish
		puts
		puts "#{@winner.name.upcase} wins the game with #{@winner.score} points!".center(70)
	end
end