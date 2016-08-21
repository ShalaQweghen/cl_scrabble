require_relative "./lib/board.rb"
require_relative "./lib/bag.rb"
require_relative "./lib/player.rb"
require_relative "./lib/game_logic.rb"
require_relative "./lib/point_methods.rb"
require_relative "./lib/letter_word_methods.rb"

class Game
	include GameLogic
	include PointMethods
	include LetterWordMethods

	def initialize(name)
		@player = Player.new(name)
		@board = Board.new
		@bag = Bag.new
		@non_discard = []
		@turn = 1
		start
		proceed
	end

	def start
		@board.display
		@player.draw_letters(@bag.bag, @player.letters)
		turn_statement
		display_letters
	end

	def proceed
		while true
			@player.proceed
			give_points
			place_word
			discard_used_letters
			@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
			@board.display
			turn_statement
			display_letters
		end
	end

	def turn_statement
		puts "Player: #{@player.name}"
		puts "Total Points: #{@player.score}"
	end

	def give_points
		word_range
		calculate_points
		@player.score += @sum unless @sum.nil?
	end
end

Game.new("shero")
