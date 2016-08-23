require_relative "./lib/board.rb"
require_relative "./lib/bag.rb"
require_relative "./lib/player.rb"
require_relative "./lib/game_logic.rb"
require_relative "./lib/point_methods.rb"
require_relative "./lib/letter_word_methods.rb"
require_relative "./lib/extra_word.rb"

class Game
	include GameLogic
	include PointMethods
	include LetterWordMethods
	include ExtraWord

	def initialize
		@board = Board.new
		@bag = Bag.new
		@dic = File.open("./lib/dic/sowpods.txt").read.split("\n")
		@non_discard = []
		@turns = 1
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
		while true
			@board.display
			turn_statement
			display_letters
			ask_pass
			if @response
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
			non_discard
			if @dic.include?(@player.word) && @set.all? { |spot| extra_word(spot) }
				give_points
				place_word
				discard_used_letters
				@player.draw_letters(@bag.bag, @player.letters, 7 - @player.letters.size)
				turn
				turn_pointer
				whose_turn
			end
		end
	end

	def turn_statement
		puts "Player: #{@player.name}"
		puts "Total Points: #{@player.score}"
	end

	def give_points
		calculate_points
		@player.score += @sum unless @sum.nil?
	end
end

Game.new
