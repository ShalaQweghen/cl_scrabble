class Board
	attr_accessor :board

	def initialize
		@board = {}
		prepare_board
		@bold_on = "\033[1m"
		@bold_off = "\033[0m"
		place_bonus
	end

	def display
		blocks
		rows = split_rows.reverse
		row_number = 15
		puts "     a   b   c   d   e   f   g   h   i   j   k   l   m   n   o"
		puts "   #{@lcu + @t_line * 14 + @ver + @ver + @ver + @rcu}"
		rows.each do |row|
			if row_number < 10
				print "#{row_number}  "
			else
				print "#{row_number} "
			end
			row.each do |value|
				if value == "3w"
					print "#{@hor}\x1b[31m#{value} \x1b[00m"
				elsif value == "2w"
					print "#{@hor}\x1b[35m#{value} \x1b[00m"
				elsif value == "3l"
					print "#{@hor}\x1b[34m#{value} \x1b[00m"
				elsif value == "2l"
					print "#{@hor}\x1b[36m#{value} \x1b[00m"
				else
					print "#{@hor}#{@bold_on} #{value} #{@bold_off}"
				end
			end
			print "#{@hor} #{row_number}"
			row_number -= 1
			if row_number > 0
				puts "\n   #{@lcm + @m_line * 14 + @ver + @ver + @ver + @rcm}"
			else
				puts "\n   #{@lcd + @b_line * 14 + @ver + @ver + @ver + @rcd}"
			end
		end
		puts "     a   b   c   d   e   f   g   h   i   j   k   l   m   n   o"
	end

	private

	def prepare_board
		letters = ("a".."o").to_a
		numbers = (1..15).to_a
		numbers.each do |n|
			letters.each do |l|
				@board[(l + n.to_s).to_sym] = " "
			end
		end
	end

	def split_rows
		@board.values.each_slice(15).to_a
	end

	def blocks
		@t_line = "\u2550\u2550\u2550\u2566"
		@m_line = "\u2550\u2550\u2550\u256C"
		@b_line = "\u2550\u2550\u2550\u2569"
		@hor = "\u2551"
		@ver = "\u2550"
		@lcu = "\u2554"
		@rcu = "\u2557"
		@lcm = "\u2560"
		@rcm = "\u2563"
		@lcd = "\u255A"
		@rcd = "\u255D"
	end

	def w3_bonus
		w3 = %w[a1 a8 a15 h15 o15 o8 o1]
		w3.each do |s|
			@board[s.to_sym] = "3w"
		end
	end

	def w2_bonus
		w2 = %w[b2 c3 d4 e5 b14 c13 d12 e11 n2 m3 l4 k5 n14 m13 l12 k11]
		w2.each do |s|
			@board[s.to_sym] = "2w"
		end
	end

	def l3_bonus
		l3 = %w[b6 b10 n6 n10 f2 f6 f10 f14 j2 j6 j10 j14]
		l3.each do |s|
			@board[s.to_sym] = "3l"
		end
	end

	def l2_bonus
		l2 = %w[a4 a12 c7 c9 d1 d8 d15 g3 g7 g9 g13 h4 h12 o4 o12 m7 m9 l1 l8 l15 i3 i7 i9 i13]
		l2.each do |s|
			@board[s.to_sym] = "2l"
		end
	end

	def place_bonus
		w3_bonus
		w2_bonus
		l3_bonus
		l2_bonus
	end
end