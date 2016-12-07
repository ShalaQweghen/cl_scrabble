require "socket"
require_relative "./game.rb"

if ARGV[0]
	server = TCPServer.open("0.0.0.0", 2000)

	loop do
		Thread.start(server.accept) do |stream|
			Game.new(stream: stream, network: true)
			stream.close
		end
	end
else
	Game.new(network: false)
end