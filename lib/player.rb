class Player
  attr_accessor :letters, :score, :turn_pointer, :name, :input, :output, :rejected
  attr_reader :word, :start, :direction, :passed, :is_passing

  def initialize(input=STDIN, output=STDOUT)
    @letters = []
    @score = 0
    @input = input
    @output = output
    @turn_pointer = 0
    @is_passing = false
    @rejected = false
  end

  def pick_from(bag)
    bag.shuffle!.pop unless bag.empty?
  end

  def draw_letters(bag, letters=[], amount=7)
    amount.times { @letters << pick_from(bag) }
    return @letters.delete_if { |letter| letter.nil? }
  end

  def pass
    @output.puts "\nEnter the letter(s) you want to pass:"
    @passed = @input.gets.chomp.upcase.gsub(/[^A-Z@]/, '').chars
  end

  def make_move
    @is_passing = false
    @output.puts "\nEnter your move (e.g. h8 r money):"
    @start, @direction, @word = @input.gets.chomp.downcase.split
    if @start == 'pass'
      @is_passing = true
    elsif @start == 'save'
      return
    elsif !%w[r d].include?(@direction)
      @output.puts "\n=================================================================="
      @output.puts "Your direction should be either 'r' for right or 'd' for down..."
      @output.puts "=================================================================="
      make_move
    elsif !@word
      @output.puts "\n=================================================================="
      @output.puts "Don't forget to enter your word.".center(70)
      @output.puts "=================================================================="
      make_move
    else
      @word.upcase!
    end
  end

  def to_s
    return "#{@name} has got #{@score} points.".center(70)
  end
end