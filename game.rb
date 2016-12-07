require_relative "./lib/require_files.rb"

class Game
	include GameMethods
	include PointMethods
	include LetterWordMethods
	include ExtraWordMethods
	include LegalMoveMethods
	include PlayerMethods
	include SaveLoadMethods

	def initialize(config)
		@board = Board.new
		@bag = Bag.new
		@dic = File.open("./lib/dic/sowpods.txt").read.split("\n")
		@non_discard = []
		@word_list = []
		@turns = 1
		@pass = 0
		@points = []
		@stream = config[:stream]
		@is_on_network = config[:network]
		@output = @stream || STDOUT
		@input = @stream || STDIN
		@players = 2
		@bold_on = "\033[1m"
		@bold_off = "\033[0m"
		give_options unless @is_on_network
		start_new_or_saved_game
	end

	def start
		welcome
		set_players_number unless @is_on_network
		get_player_names
		set_players
		set_players_list
		@players_list.each { |player| player.draw_letters(@bag.bag, player.letters, 7 - player.letters.size)}
		set_whose_turn
		proceed
	end

	def proceed
		begin
			until @game_over
				switch_players
				turn_beginning
				@sum = 0
				@player.pick_starting_square(@output, @input)
				save if @player.start.to_s == 'save'
				if pass_turn?
					@pass += 1
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

	def turn_beginning
		@board.display(@output)
		turn_statement
		display_letters
	end

	def pass_turn?
		if @player.is_passing
			game_over?
			@player.pass(@output, @input)
			begin
				change_letters(@player.passed)
			rescue TypeError
				rescue_type_error
			end
			@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
			turn_beginning
			@output.puts "\n\nWaiting for the other player to make a word..." if @is_on_network
			return true
		end
	end

	def continue_turn
		@player.proceed(@output, @input)
		set_word_range
		set_wild_tile
		set_non_discard
		if (@dic.include?(@player.word) && @set.all? { |spot| extra_word?(spot) }) && (legal_move?)
			begin
				discard_used_letters
			rescue TypeError
				rescue_type_error
				@player.pick_starting_square(@output, @input)
				continue_turn
				proceed
			end
			give_points
			place_word
			@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
			turn_beginning if @is_on_network
			@output.puts "\n\nWaiting for the other player to make a word..." if @is_on_network
			turn
			set_turn_pointer
			set_whose_turn
			@pass = 0
		end
	end

	def end_game
		set_winner
		finish
	end
end