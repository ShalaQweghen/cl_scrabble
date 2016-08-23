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

	def ask_pass
		print "Do you want to pass and change letters?(y/n) "
		@response = gets.chomp.downcase
		case @response
		when "y" then @response = true
		when "n" then @response = false
		end
		return @response
	end
end