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
		@passed = input.gets.chomp.upcase.gsub(/[^A-Z@]/, '').chars
	end

	def make_move(output, input)
    @is_passing = false
    output.puts "\nEnter your move (h8 r money):"
    @start, @direction, @word = input.gets.chomp.downcase.split
    if @start.to_s == 'pass'
      @is_passing = true
    elsif !%w[r d].include?(@direction) && @direction
      output.puts "\n==============================================================="
      output.puts "Your direction should be either 'r' for right or 'd' for down."
      output.puts "==============================================================="
      make_move(output, input)
    end
    @word.upcase! if @word
  end
end