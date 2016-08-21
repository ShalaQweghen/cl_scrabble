module GameLogic

	def display_letters
		puts "\u2551 #{@player.letters.join(" - ")} \u2551"
	end

	def turn
		@turns += 1
	end

	def add_to_word_list
		@wordlist[@word] = @set
	end
end