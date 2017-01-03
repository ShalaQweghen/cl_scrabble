require_relative "./require_files.rb"

class Game
	include Scrabble

	def initialize(config={})
		@board = Board.new
		@bag = Bag.new
		@dic = File.open("./lib/dic/sowpods.txt").read.split("\n")
		@non_discard = []
		@word_list = []
		@turns = 1
		@pass = 0
		@points = []
		@limit = config[:limit]
		@stream = config[:stream]
		@on_network = config[:network]
		@challenging = config[:challenge]
		@saved = config[:saved]
		@output = @stream || STDOUT
		@input = @stream || STDIN
		@players = 2
		@bold_on = "\033[1m"
		@bold_off = "\033[0m"
		start_new_or_saved_game
	end

	def start
		set_players_number unless @on_network
		get_player_names
		set_players
		set_players_list
		@players_list.each { |player| player.draw_letters(@bag.bag, player.letters, 7 - player.letters.size) }
		set_whose_turn
		set_time_limit(@limit)
		proceed
	end

	def proceed
		begin
			until @game_over
				@output.puts "\nWaiting for the other player to make a word..." if @on_network
				reset_word_list
				switch_stream
				start_turn
				@player.make_move(@output, @input)
				save if @player.start.to_s == 'save'
				if passing_turn?
					@pass += 1
					check_game_over
					turn
					set_turn_pointer
					set_whose_turn
					next
				end
				continue_turn
			end
		rescue Interrupt
			rescue_interrupt
		end
		end_game
	end

	def start_turn
		display_turn_info
		if @turns == 1 && @on_network
			@board.display(@stream)
			display_turn_statement(@player_2, @stream)
			display_letters(@player_2, @stream)
			@stream.puts "\nWaiting for the other player to make a word..."
		end
	end

	def passing_turn?
		if @player.is_passing
			@player.pass(@output, @input)
			begin
				change_letters(@player.passed)
			rescue TypeError
				rescue_type_error
			end
			@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
			return true
		end
	end

	def continue_turn
		process_word
		if valid_word?
			begin
				discard_used_letters
			rescue TypeError
				rescue_type_error
				@player.make_move(@output, @input)
				continue_turn
				proceed
			end
			if (@limit && Time.now < @limit) || !@limit
				give_points
				place_word
				@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
				start_turn if @on_network
				end_turn
			elsif Time.now >= @limit
				@game_over = true
			end
		elsif @challenging
			@output.puts "\n'#{@player.word}' is not present in the dictionary. Your turn is passed."
			@limit && Time.now >= @limit ? @game_over = true : end_turn
		end
	end

	def end_turn
		turn
		set_turn_pointer
		set_whose_turn
		@pass = 0
		check_game_over
	end

	def end_game
		set_winner
		finish
	end
end