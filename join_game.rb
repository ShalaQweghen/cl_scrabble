require "socket"

hostname = ARGV[0]
port = 2000
stream = TCPSocket.open(hostname, port)

system('clear')

puts "Connected to the game... Waiting for the opponent..."
puts
begin
  while line = stream.gets.chomp
  	puts line
  	if line[-1] == ":"     # If a line ends with a colon, it means that it asks for an input.
  		answer = gets.chomp
  		stream.puts(answer)
  	end
  end
rescue NoMethodError
  stream.close
end