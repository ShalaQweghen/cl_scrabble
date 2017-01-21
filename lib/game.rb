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
		@names = config[:names] || {}
		@limit = config[:limit]
		@stream = config[:stream]
		@on_network = config[:network]
		@challenging = config[:challenge]
		@saved = config[:saved]
		@players = @on_network ? config[:stream].length + 1 : 2
		@bold_on = "\033[1m"
		@bold_off = "\033[0m"
		start_new_or_saved_game
	end

	def start
		set_players_number
		set_players
		set_players_list
		get_player_names
		get_players_ready
		set_whose_turn
		set_time_limit
		proceed
	end

	def proceed
		begin
			until @game_over
				reset_word_list
				display_turn_info
				@player.make_move
				save_game if @player.start.to_s == 'save'
				if @player.is_passing
					pass_turn
				else
					continue_turn
				end
			end
		rescue Interrupt
			rescue_interrupt
		end
		end_game
	end

	def pass_letters
		@player.pass
		begin
			change_letters
		rescue TypeError
			rescue_type_error
			pass_letters
		end
		@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
	end

	def pass_turn
		pass_letters
		@pass += 1
		check_game_over
		turn
		set_turn_pointer
		set_whose_turn
	end

	def continue_turn
		process_word
		if valid_word?
			begin
				discard_used_letters
			rescue TypeError
				rescue_type_error
				@player.make_move
				continue_turn
				proceed
			end
			if (@limit && Time.now < @limit) || !@limit
				give_points
				place_word
				@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
				display_turn_info if @on_network
				end_turn
			elsif Time.now >= @limit
				@game_over = true
			end
		elsif @challenging
			@player.rejected = true
			if @limit && Time.now >= @limit
				@game_over = true
			else
				end_turn
			end
		else
			@player.output.puts "\n=================================================================="
			@player.output.puts "'#{@player.word}' is not present in the dictionary. Try again.".center(70)
			@player.output.puts "=================================================================="
			@player.make_move
			continue_turn
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
		put_finish_message
	end
end