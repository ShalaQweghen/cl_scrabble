require_relative "./lib/board.rb"
require_relative "./lib/bag.rb"
require_relative "./lib/player.rb"
require_relative "./lib/game_logic.rb"
require_relative "./lib/point_methods.rb"
require_relative "./lib/letter_word_methods.rb"
require_relative "./lib/extra_word.rb"
require_relative "./lib/legal_move.rb"

class Game
	include GameLogic
	include PointMethods
	include LetterWordMethods
	include ExtraWord
	include LegalMove

	def initialize
		@board = Board.new
		@bag = Bag.new
		@dic = File.open("./lib/dic/sowpods.txt").read.split("\n")
		@non_discard = []
		@word_list = []
		@turns = 1
		@pass = 0
		@points = []
		@game_over = false
		how_many_players
		start
		proceed
	end

	def start
		pick_players
		players_list
		@players_list.each { |player| player.draw_letters(@bag.bag, player.letters, 7 - player.letters.size)}
		whose_turn
	end

	def proceed
		until @game_over
			@board.display
			turn_statement
			display_letters
			ask_pass
			if @response
				@pass += 1
				game_over?
				@player.pass
				change_letters(@player.passed)
				@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
				turn
				turn_pointer
				whose_turn
				next
			end
			@player.proceed
			word_range
			set_wild_tile
			non_discard
			if (@dic.include?(@player.word) && @set.all? { |spot| extra_word(spot) }) && (legal_move?)
				give_points
				place_word
				discard_used_letters
				@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
				turn
				turn_pointer
				whose_turn
				@pass = 0
			end
		end
		set_winner
		finish
	end

	def turn_statement
		puts "Player: #{@player.name}\t\t|  Total Points: #{@player.score}"
		puts "Letters Left in Bag: #{@bag.bag.size}\t|  Word by Prev. Player: #{@word_list[0] || 0} for #{@sum || 0} points"
		@word_list.delete_at(0)
		@sum = 0
	end
end

Game.new
