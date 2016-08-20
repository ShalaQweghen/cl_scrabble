class Player

	def initialize(name)
		@name = name
		@letters = ["A","B","C"]
		@hor = "\u2550"
	end

	def display_letters
		puts "\u2554" + @hor * @letters.size + "\u2557"
		puts "\u2551#{@letters.join(", ")}\u2551"
		puts "\u255A#{"\u2550" * @letters.size}\u255D"
	end
end

player = Player.new("shero")
player.display_letters


