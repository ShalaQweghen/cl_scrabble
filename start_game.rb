require "socket"
require_relative "lib/game.rb"

def give_options
  puts "\n0 => README"
  puts "1 => Start a new game on normal mode"
  puts "2 => Start a new game on challenge mode"
  puts "3 => Play on the network on normal mode"
  puts "4 => Play on the network on challenge mode"
  puts "5 => Load a saved game"
  puts "6 => Exit"
  print "\nPick an action: "

  case gets.chomp
  when "0"
    instr = File.open('README.txt') { |f| f.read }
    puts instr
    print "Press enter to go back to options:"
    gets
    give_options
  when "1"
    Game.new
  when "2"
    Game.new(challenge: true)
  when "3"
    server = TCPServer.open("0.0.0.0", 2000)
    puts "\nlocalhost:2000 fired up on normal mode... Waiting for an opponent to join..."
    puts
    loop do
      Thread.start(server.accept) do |stream|
        Game.new(stream: stream, network: true, challenge: false)
        stream.close
      end
    end
  when "4"
    server = TCPServer.open("0.0.0.0", 2000)
    puts "localhost:2000 fired up on challenge mode... Waiting for an opponent to join..."
    puts
    loop do
      Thread.start(server.accept) do |stream|
        Game.new(stream: stream, network: true, challenge: true)
        stream.close
      end
    end
  when "5"
    Game.new(saved: true)
  when "6"
    exit
  else
    give_options
  end
end

system("clear")
puts "COMMANDLINE SCRABBLE".center(50)
give_options