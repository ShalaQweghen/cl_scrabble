# ===============================
# Methods related to game details
# ===============================
module Scrabble

	def set_time_limit
		# The initial @limit stores minutes specified by the user (otherwise nil). The method adds those minutes to the
		# time at the moment of the game start. @limit now stores the datetime object indicating the end
		# of the game.
    @limit = Time.now. + @limit * 60 if @limit
  end

	def rescue_interrupt
		puts "\nThe game is about to be canceled by a player. Do you want to save the game?(y/n):"
		case gets.chomp.downcase
		when "y" then save_game
		when "n" then exit_game
		end
	end

	def display_error_message
		@player.output.puts "\n=================================================================="
		@player.output.puts "One of the letters is not present on your rack!".center(70)
		@player.output.puts "==================================================================\n"
	end

	def display_mistake_message
		if @turns == 1 && @player.start != "h8"
			@player.output.puts "\n=================================================================="
			@player.output.puts "The first word should start from square 'h8'.".center(70)
			@player.output.puts "=================================================================="
		else
			@player.output.puts "\n=================================================================="
			@player.output.puts "'#{@player.word}' is not present in the dictionary. Try again.".center(70)
			@player.output.puts "=================================================================="
		end
	end

	def exit_game
		at_exit do
			puts "\nGOODBYE!"
			if @on_network
				@streams.each { |s| s.puts "\nGOODBYE!" }
			end
		end
		exit
	end

	def display_letters
		@players_list.each do |player|
			next if !@on_network && player != @player
			player.output.puts
			player.output.puts "\u2551 #{player.letters.join(" - ")} \u2551".center(70)
		end
	end

	def display_turn_info
		if @on_network
			@players_list.each { |player| @board.display(player.output) }
		else
			@board.display(@player.output)
		end
		@player.output.puts "\nThe game will end at #{@limit.strftime('%H:%M')}.\n" if @limit
		display_turn_statement
		display_letters
		@players_list.each do |player|
			if player.is_rejected && @on_network
				player.output.puts "\n=================================================================="
				player.output.puts "'#{player.word}' is not present in the dictionary. Your turn is passed."
				player.output.puts "=================================================================="
			end
			player.is_rejected = false
			player.output.puts "\nWaiting for the other player to make a word..." if @player != player && @on_network
		end
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

	def display_turn_statement
		@players_list.each do |player|
				next if !@on_network && player != @player
				player.output.puts "\n#{@bold_on}Player:#{@bold_off} #{player.name}\t\t#{@bold_on}|#{@bold_off}  #{@bold_on}Total Points:#{@bold_off} #{player.score}"
				player.output.puts "#{@bold_on}Letters Left in Bag:#{@bold_off} #{@bag.bag.size}\t#{@bold_on}|#{@bold_off}  #{@bold_on}Words Prev. Made:#{@bold_off} #{@prev_words || 0} for #{@sum || 0} points"
		end
	end

	def pass_letters
		@player.pass
		begin
			change_letters
		rescue TypeError
			display_error_message
			pass_letters
		end
		draw_letters
	end

	# The game is over if the time limit is up, any one of the players finishes their letters and there are no letters left
	# in the bag or a certain number of turns are passed one after another.
	def check_game_over
		@game_over = true if @limit && Time.now  >= @limit
		@game_over = true if @players_list.any? { |player| player.letters.empty? }
		if @players == 2 && @pass == 6
			@game_over = true
		elsif @players == 3 && @pass == 9
			@game_over = true
		elsif @players == 4 && @pass == 12
			@game_over = true
		end
	end

	def finish_message(output=STDOUT)
		output.puts "TIME IS UP!".center(70) if @limit
		output.puts
		output.puts @players_list		# => This prints each of the players in the list.
		output.puts
		output.puts "#{@winner.name.upcase} wins the game with #{@winner.score} points!".center(70)
		output.puts
	end

	def put_finish_message
		unless @on_network
			finish_message
		else
			@players_list.each { |player| finish_message(player.output) }
		end
	end
end