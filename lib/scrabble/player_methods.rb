# ==========================
# Methods related to players
# ==========================
module Scrabble

	def set_players_number
		unless @on_network
			puts "\nHow many players will play the game?: "
			@players = gets.chomp.to_i
			unless (2..4).include?(@players)
				puts "\n=================================================================="
				puts "You can play as 2, 3 or 4 players.".center(70)
				puts "=================================================================="
				set_players_number
			end
		end
	end

	def set_players
		@player_1 = Player.new
		if @on_network
			@player_2 = Player.new(@streams[0], @streams[0])
			@player_3 = Player.new(@streams[1], @streams[1]) if @players >= 3
			@player_4 = Player.new(@streams[2], @streams[2]) if @players == 4
		else
			@player_2 = Player.new
			@player_3 = Player.new if @players >= 3
			@player_4 = Player.new if @players == 4
		end
	end

	def set_players_list
		@players_list = [@player_1, @player_2]
		@players_list << @player_3 if @players >= 3
		@players_list << @player_4 if @players == 4
		@players_list.shuffle!		# => Randomises the players order.
		# Turn pointers are important that they help to decide whose turn it is. The initial
		# pointers are each player's starting turn number and it increases accordingly each turn.
		@players_list.each_with_index { |player, idx| player.turn_pointer = idx + 1 }
	end

	def get_player_names
		if @players >= 2
			@players_list[0].output.puts "Enter Player 1's name:"
			@players_list[0].name = @players_list[0].input.gets.chomp.capitalize
			@players_list[1].output.puts "Enter Player 2's name:"
			@players_list[1].name = @players_list[1].input.gets.chomp.capitalize
		end
		if @players >= 3
			@players_list[2].output.puts "Enter Player 3's name:"
			@players_list[2].name = @players_list[2].input.gets.chomp.capitalize
		end
		if @players == 4
			@players_list[3].output.puts "Enter Player 4's name:"
			@players_list[3].name = @players_list[3].input.gets.chomp.capitalize
		end
	end

	def get_players_ready
		@player = @players_list[0]
		@players_list.each { |player| player.draw_letters(@bag.bag, 7 - player.letters.size) }
	end

	def set_whose_turn
		@players_list.each { |player| @player = player if player.turn_pointer == @turns }
	end

	def set_winner
		@players_list.each { |player| @points << player.score }
		@winner = @players_list[@points.index(@points.max)]
	end

	def draw_letters
		@player.draw_letters(@bag.bag, 7 - @player.letters.size)
	end
end