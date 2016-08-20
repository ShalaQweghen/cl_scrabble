class Bag
	attr_accessor :bag

	def initialize
		@bag = []
		fill_bag
	end

	private

	def p1
		%w[Q Z J X K].each do |l|
			1.times { @bag << l }
		end

	end

	def p2
		%w[F H V W Y B C M P @].each do |l|
			2.times { @bag << l }
		end
	end

	def p3
		%w[G].each do |l|
			3.times { @bag << l }
		end
	end

	def p4
		%w[D U S L].each do |l|
			4.times { @bag << l }
		end
	end

	def p6
		%w[T R N].each do |l|
			6.times { @bag << l }
		end
	end

	def p8
		%w[O].each do |l|
			8.times { @bag << l }
		end
	end

	def p9
		%w[I A].each do |l|
			9.times { @bag << l }
		end
	end

	def p12
		%w[E].each do |l|
			12.times { @bag << l }
		end
	end

	def fill_bag
		p1
		p2
		p3
		p4
		p6
		p8
		p9
		p12
	end
end

#bag = Bag.new
#puts bag.bag.size
#p bag.bag
