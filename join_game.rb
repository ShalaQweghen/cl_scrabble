require "socket"

hostname = ARGV[0]
port = 2000
stream = TCPSocket.open(hostname, port)

system('clear')

while line = stream.gets.chomp
	puts line
	if line[-1] == ":"
		answer = STDIN.gets.chomp
		stream.puts(answer)
	end
end
stream.close