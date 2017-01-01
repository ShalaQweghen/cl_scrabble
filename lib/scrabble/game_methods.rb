# ===============================
# Methods related to game details
# ===============================
module Scrabble

	def switch_stream
		if @on_network
			if @turns.odd?
				@input = STDIN
				@output = STDOUT
			else
				@input = @stream
				@output = @stream
			end
		end
	end


	def rescue_interrupt
		print "\nDo you want to save the game?(y/n): "
		response =gets.chomp.downcase
		case response
		when "y" then save
		when "n" then exit_game
		end
	end

	def rescue_type_error
		@output.puts "\n==============================================="
		@output.puts "One of the letters is not present on your rack!"
		@output.puts "==============================================="
	end

	def exit_game
		at_exit do
			@output.puts
			@output.puts "GOODBYE!"
			if @on_network
				STDOUT.puts
				STDOUT.puts "GOODBYE!"
			end
		end
		exit
	end

	def display_letters(player=@player, output=@output)
		output.puts
		output.puts "\u2551 #{player.letters.join(" - ")} \u2551".center(70)
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

	def display_turn_statement(player=@player, output=@output)
		output.puts "\n#{@bold_on}Player:#{@bold_off} #{player.name}\t\t#{@bold_on}|#{@bold_off}  #{@bold_on}Total Points:#{@bold_off} #{player.score}"
		output.puts "#{@bold_on}Letters Left in Bag:#{@bold_off} #{@bag.bag.size}\t#{@bold_on}|#{@bold_off}  #{@bold_on}Words Prev. Made:#{@bold_off} #{@prev_words || 0} for #{@sum || 0} points"
	end

	def check_game_over
		if @players == 2
			@game_over = true if @pass == 6
		elsif @players == 3
			@game_over = true if @pass == 9
		elsif @players == 4
			@game_over = true if @pass == 12
		end
	end

	def finish
		@output.puts
		@output.puts "#{@winner.name.upcase} wins the game with #{@winner.score} points!".center(70)
		if @on_network
			@output.puts
			@output.puts "#{@winner.name.upcase} wins the game with #{@winner.score} points!".center(70)
		end
	end
end