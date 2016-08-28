class Player
	attr_accessor :letters, :score, :turn_pointer
	attr_reader :name, :word, :start, :direction, :passed

	def initialize(name, turn_pointer)
		@name = name
		@letters = []
		@score = 0
		@turn_pointer = turn_pointer
	end

	def pick_from(bag)
		unless bag.empty?
			bag.shuffle!.pop
		else
			puts "No tiles left in the bag!"
		end
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
		print "\nEnter the starting square of your word: "
		@start = gets.chomp.downcase.to_sym
	end

	def pick_direction
		print "Enter the direction of the word (right/down): "
		@direction = gets.chomp.downcase
		unless %w[right down].include?(@direction)
			puts "\n=================================================="
			puts "Your direction should be either 'right' or 'down'."
			puts "=================================================="
			pick_direction
		end
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