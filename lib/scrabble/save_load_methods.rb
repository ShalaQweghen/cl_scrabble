# =============================================
# Methods related to saving and loading a game
# =============================================
require "yaml"

module Scrabble

	def start_new_or_saved_game
		if @saved
			print "Enter saved game name: "
			@save_name = gets.chomp.downcase
			load_or_new_game
		else
			start
		end
	end

	def save_game
		@player.output.puts "Please enter a name for your saved game:"
		@save_name = @player.input.gets.chomp.downcase
		config = {player: @player, 
							player_1: @player_1, 
							player_2: @player_2, 
							player_3: @player_4, 
							player_4: @player_4, 
							board: @board, 
							bag: @bag, 
							pass: @pass, 
							turns: @turns, 
							word_list: @word_list, 
							challenging: @challenging,
							players_list: @players_list }
		Dir.mkdir("./saves") unless Dir.exists?("./saves")
		File.open("./saves/#{@save_name}.txt", "w") { |file| file.puts(YAML::dump(config)) }
		exit_game
	end

	def load_or_new_game
		if File.exist?("./saves/#{@save_name}.txt")
			load_game
		else
			start_new_game
		end
	end

	def load_game
		file = File.read("./saves/#{@save_name}.txt")
		config = YAML::load(file)
		@player_1 = config[:player_1]
		@player_2 = config[:player_2]
		@player_3 = config[:player_3]
		@player_4 = config[:player_4]
		@board = config[:board]
		@bag = config[:bag]
		@pass = config[:pass]
		@turns = config[:turns]
		@player = config[:player]
		@word_list = config[:word_list]
		@challenging = config[:challenging]
		@players_list = config[:players_list]
		# Assigned the appropriate input-output streams to players.
		@players_list.each do |player|
			# If a player's name is not in the stream names hash, it is assigned the local stream.
			if @names[player.name]
				player.output = @names[player.name]
				player.input = @names[player.name]
			else
				player.output = STDOUT
				player.input = STDIN
			end
		end
		proceed
	end

	def start_new_game
		puts "NO SAVED GAMES FOUND!".center(50)
		puts "Starting a new game...".center(50)
		puts "\n"
		start
	end
end