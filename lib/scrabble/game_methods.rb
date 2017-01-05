# ===============================
# Methods related to game details
# ===============================
module Scrabble

	def switch_stream
		if @on_network
			@input = @player.input
			@output = @player.output
		end
	end

	def set_time_limit(min)
    @limit = Time.now. + min * 60 if min
  end

	def rescue_interrupt
		@output.puts "\nDo you want to save the game?(y/n):"
		case @input.gets.chomp.downcase
		when "y" then save
		when "n" then exit_game
		end
	end

	def rescue_type_error
		@output.puts "\n==============================================="
		@output.puts "One of the letters is not present on your rack!"
		@output.puts "===============================================\n"
	end

	def exit_game
		at_exit do
			puts "\nGOODBYE!"
			if @on_network
				@stream.each { |s| s.puts "\nGOODBYE!" }
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

	def display_saved_board_on_network
		@board.display(STDOUT)
		display_turn_statement
		display_letters(@player_1, STDOUT)
		@board.display(@stream)
		display_turn_statement(@player_2, @stream)
		display_letters(@player_2, @stream)
		if @output == STDOUT
			@stream.puts "\nWaiting for the other player to make a word..."
		else
			STDOUT.puts "\nWaiting for the other player to make a word..."
		end
		@saved = false
	end

	def display_turn_info
		if @saved && @on_network
			display_saved_board_on_network
		else
			if @on_network
				@players_list.each { |player| @board.display(player.output) }
			else
				@board.display(@player.output)
			end
			@output.puts "\nThe game will end at #{@limit.strftime('%H:%M')}.\n" if @limit
			display_turn_statement
			display_letters
		end
		@players_list.each do |player|
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

	def check_game_over
		@game_over = true if @limit && Time.now  >= @limit
		@game_over = true if @players_list.any? { |player| player.letters.empty? }
		if @players == 2
			@game_over = true if @pass == 6
		elsif @players == 3
			@game_over = true if @pass == 9
		elsif @players == 4
			@game_over = true if @pass == 12
		end
	end

	def finish
		puts "TIME IS UP!".center(70) if @limit
		puts
		puts @players_list
		puts
		puts "#{@winner.name.upcase} wins the game with #{@winner.score} points!".center(70)
		puts
		if @on_network
			@stream.each do |s|
				s.puts "TIME IS UP!".center(70) if @limit
				s.puts
				s.puts @players_list
				s.puts
				s.puts "#{@winner.name.upcase} wins the game with #{@winner.score} points!".center(70)
				s.puts
			end
		end
	end
end