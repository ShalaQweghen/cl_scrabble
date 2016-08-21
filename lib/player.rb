require_relative "./modifications.rb"

class Player
	attr_accessor :letters
	attr_reader :name

	def initialize(name)
		@name = name
		@letters = []
	end

	def display_letters
		puts "\u2551 #{@letters.join(" - ")} \u2551"
	end

	# Gets a random letter from the letter list.
	def pick_from(bag)
		bag.shuffle!.pop
	end

	# Add specific amount of letter to the player's letters. Default values are for the first
	# draw at the beginning of the game.
	def draw_letters(bag, letters=[], amount=7)
		amount.times { letters << pick_from(bag) }
		return letters
	end

	def make_word
		print "Enter your word: "
		word = gets.chomp.upcase
	end

	def discard_used_letters(word)
		word.chars.each { |l| @letters.delete_at(@letters.index(l)) }
	end
end

#bag = ["Q", "Z", "J", "X", "K", "F", "F", "H", "H", "V", "V", "W", "W", "Y", "Y", "B", "B", "C", "C", "M", "M", "P", "P", "@", "@", "G", "G", "G", "D", "D", "D", "D", "U", "U", "U", "U", "S", "S", "S", "S", "L", "L", "L", "L", "T", "T", "T", "T", "T", "T", "R", "R", "R", "R", "R", "R", "N", "N", "N", "N", "N", "N", "O", "O", "O", "O", "O", "O", "O", "O", "I", "I", "I", "I", "I", "I", "I", "I", "I", "A", "A", "A", "A", "A", "A", "A", "A", "A", "E", "E", "E", "E", "E", "E", "E", "E", "E", "E", "E", "E"]
#player = Player.new("shero")
#player.draw_letters(bag, player.letters)
#player.display_letters
#player.discard_used_letters(player.make_word)
#player.draw_letters(bag, player.letters, 7-player.letters.size)
#player.display_letters