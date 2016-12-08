class Player
	attr_accessor :letters, :score, :turn_pointer
	attr_reader :name, :word, :start, :direction, :passed, :is_passing

	def initialize(name, turn_pointer)
		@name = name
		@letters = []
		@score = 0
		@turn_pointer = turn_pointer
		@is_passing = false
	end

	def pick_from(bag)
		unless bag.empty?
			bag.shuffle!.pop
		else
			@output.puts "No tiles left in the bag!"
		end
	end

	def draw_letters(bag, letters=[], amount=7)
		amount.times { letters << pick_from(bag) }
		return letters
	end

	def pass(output, input)
		output.puts "Enter the letters you want to pass:"
		@passed = input.gets.chomp.upcase.chars
	end

	def pick_starting_square(output, input)
		@is_passing = false
		output.puts "\nEnter the starting square of your word:"
		@start = input.gets.chomp.downcase.to_sym
		if @start.to_s == 'pass'
			@is_passing = true
		end
	end

	def pick_direction(output, input)
		output.puts "Enter the direction of the word (r/d):"
		@direction = input.gets.chomp.downcase
		unless %w[r d].include?(@direction)
			output.puts "\n==============================================================="
			output.puts "Your direction should be either 'r' for right or 'd' for down."
			output.puts "==============================================================="
			pick_direction(output, input)
		end
	end

	def make_word(output, input)
		output.puts "Enter your word:"
		@word = input.gets.chomp.upcase
	end

	def proceed(output, input)
		pick_direction(output, input)
		make_word(output, input)
	end
end