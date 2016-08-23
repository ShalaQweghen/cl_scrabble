class Player
	attr_accessor :letters, :score
	attr_reader :name, :word, :start, :direction, :passed

	def initialize(name)
		@name = name
		@letters = []
		@score = 0
	end

	def pick_from(bag)
		bag.shuffle!.pop
	end

	def draw_letters(bag, letters=[], amount=7)
		amount.times { letters << pick_from(bag) }
		return letters
	end

	def pass
		print "Enter the letters you want to pass: "
		@passed = gets.chomp.upcase.chars
	end

	def pick_starting_square
		print "Enter the starting square of your word: "
		@start = gets.chomp.downcase.to_sym
	end

	def pick_direction
		print "Enter the direction of the word (right/down): "
		@direction = gets.chomp.downcase
	end

	def make_word
		print "Enter your word: "
		@word = gets.chomp.upcase
	end

	def proceed
		pick_starting_square
		pick_direction
		make_word
	end
end