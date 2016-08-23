module GameLogic

	def display_letters
		puts "\u2551 #{@player.letters.join(" - ")} \u2551"
	end

	def turn
		@turns += 1
	end

	def turn_pointer
		if @players == 2
			@player.turn_pointer += 2
		elsif @players == 3
			@player.turn_pointer += 3
		elsif @players == 4
			@player.turn_pointer += 4
		end
	end

	def add_to_word_list
		@wordlist[@word] = @set
	end

	def players_list
		if @players == 2
			@players_list = [@player_1, @player_2]
		elsif @players == 3
			@players_list = [@player_1, @player_2, @player_3]
		elsif @players == 4
			@players_list = [@player_1, @player_2, @player_3, @player_4]
		end
	end

	def whose_turn
		@players_list.each do |player|
			if player.turn_pointer == @turns
				@player = player
			end
		end
	end

	def ask_pass
		print "Do you want to pass and change letters?(y/n) "
		@response = gets.chomp.downcase
		case @response
		when "y" then @response = true
		when "n" then @response = false
		end
		return @response
	end

	def how_many_players
		print "How many players will play the game? "
		@players = gets.chomp.to_i
	end

	def pick_players
		case @players
		when 2 then two_players
		when 3 then three_players
		when 4 then four_players
		end
	end

	def two_players
		@player_1 = Player.new("Shero", 1)
		@player_2 = Player.new("Zahra", 2)
		@player = @player_1
	end

	def three_players
		@player_1 = Player.new("Shero", 1)
		@player_2 = Player.new("Zahra", 2)
		@player_3 = Player.new("Zoe", 3)
		@player = @player_1
	end

	def four_players
		@player_1 = Player.new("Shero", 1)
		@player_2 = Player.new("Zahra", 2)
		@player_3 = Player.new("Zoe", 3)
		@player_4 = Player.new("Willow", 4)
		@player = @player_1
	end
end