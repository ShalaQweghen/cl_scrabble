module PlayerMethods

	def set_players_list
		if @players == 2
			@players_list = [@player_1, @player_2]
		elsif @players == 3
			@players_list = [@player_1, @player_2, @player_3]
		elsif @players == 4
			@players_list = [@player_1, @player_2, @player_3, @player_4]
		end
	end

	def get_player_names
		if @players >= 2
			STDOUT.puts "Enter Player 1's name:"
			@name_1 = STDIN.gets.chomp.capitalize
			@output.puts "Enter Player 2's name:"
			@name_2 = @input.gets.chomp.capitalize
		end
		if @players >= 3
			@output.puts "Enter Player 3's name:"
			@name_3 = @input.gets.chomp.capitalize
		end
		if @players == 4
			@output.puts "Enter Player 4's name:"
			@name_4 = @input.gets.chomp.capitalize
		end
	end

	def set_players
		if @players >= 2
			@player_1 = Player.new(@name_1, 1)
			@player_2 = Player.new(@name_2, 2)
		end
		@player_3 = Player.new(@name_3, 3) if @players >= 3
		@player_4 = Player.new(@name_4, 4) if @players == 4
		@player = @player_1
	end

	def set_winner
		@players_list.each { |player| @points << player.score }
		@winner = @points.index(@points.max)
		case @winner
		when 0 then @winner = @player_1
		when 1 then @winner = @player_2
		when 2 then @winner = @player_3
		when 3 then @winner = @player_4
		end
	end

	def set_players_number
		@output.puts "\nHow many players will play the game?: "
		@players = @input.gets.chomp.to_i
		unless (2..4).include?(@players)
			@output.puts "\n=================================="
			@output.puts "You can play as 2, 3 or 4 players."
			@output.puts "=================================="
			set_players_number
		end
	end

	def set_whose_turn
		@players_list.each do |player|
			@player = player if player.turn_pointer == @turns
		end
	end
end