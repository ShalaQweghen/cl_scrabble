class Board
	attr_accessor :board

	def initialize
		@board = {}
		@bold_on = "\033[1m"
		@bold_off = "\033[0m"
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
		prepare_board
		place_bonus
	end

	def display(output)
		rows = split_rows.reverse
		row_number = 15
		output.puts "\n     a   b   c   d   e   f   g   h   i   j   k   l   m   n   o"
		output.puts "   #{@lcu + @t_line * 14 + @ver + @ver + @ver + @rcu}"
		rows.each do |row|
			if row_number < 10
				output.print "#{row_number}  "
			else
				output.print "#{row_number} "
			end
			row.each do |value|
				if value == "3w"
					output.print "#{@hor}\x1b[31m#{value} \x1b[00m"
				elsif value == "2w"
					output.print "#{@hor}\x1b[35m#{value} \x1b[00m"
				elsif value == "3l"
					output.print "#{@hor}\x1b[34m#{value} \x1b[00m"
				elsif value == "2l"
					output.print "#{@hor}\x1b[36m#{value} \x1b[00m"
				else
					output.print "#{@hor}#{@bold_on} #{value} #{@bold_off}"
				end
			end
			output.print "#{@hor} #{row_number}"
			row_number -= 1
			if row_number > 0
				output.puts "\n   #{@lcm + @m_line * 14 + @ver + @ver + @ver + @rcm}"
			else
				output.puts "\n   #{@lcd + @b_line * 14 + @ver + @ver + @ver + @rcd}"
			end
		end
		output.puts "     a   b   c   d   e   f   g   h   i   j   k   l   m   n   o"
	end

	private

	def prepare_board
		(1..15).each do |number|
			("a".."o").each do |letter|
				@board[(letter + number.to_s).to_sym] = " "
			end
		end
	end

	def split_rows
		@board.values.each_slice(15).to_a
	end

	def place_bonus
		%w[a1 a8 a15 h15 o15 h1 o8 o1].each { |s| @board[s.to_sym] = "3w" }
		%w[b2 c3 d4 e5 b14 c13 d12 e11 n2 m3 l4 k5 n14 m13 l12 k11].each { |s| @board[s.to_sym] = "2w" }
		%w[b6 b10 n6 n10 f2 f6 f10 f14 j2 j6 j10 j14].each { |s| @board[s.to_sym] = "3l" }
		%w[a4 a12 c7 c9 d1 d8 d15 g3 g7 g9 g13 h4 h12 o4 o12 m7 m9 l1 l8 l15 i3 i7 i9 i13].each { |s| @board[s.to_sym] = "2l" }
	end
end