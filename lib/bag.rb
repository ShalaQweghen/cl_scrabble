class Bag
	attr_accessor :bag

	def initialize
		@bag = []
		fill_bag
	end

	private

	def fill_bag
		%w[Q Z J X K].each { |l| @bag << l }
		%w[F H V W Y B C M P @].each { |l| 2.times { @bag << l } }
		3.times { @bag << 'G' }
		%w[D U S L].each { |l| 4.times { @bag << l } }
		%w[T R N].each { |l| 6.times { @bag << l } }
		8.times { @bag << 'O' }
		%w[I A].each { |l| 9.times { @bag << l } }
		12.times { @bag << 'E' }
	end
end