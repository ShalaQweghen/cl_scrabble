require "socket"
require_relative "game.rb"

class Interface
  def initialize
    system("clear")
    puts "COMMANDLINE SCRABBLE".center(50)
    give_main_options
  end

  def give_main_options
    puts "\n0 => README"
    puts "1 => Game options on this computer"
    puts "2 => Game options on the network"
    puts "9 => Exit"
    print "\nPick an action: "

    case gets.chomp
    when "0"
      instr = File.open('README.txt') { |f| f.read }
      puts instr
      print "Press enter to go back to options:"
      gets
      give_main_options
    when "1" then start_local_game
    when "2" then start_network_game
    when "9" then exit
    else
      give_main_options
    end
  end

  def start_local_game
    options = give_secondary_options
    Game.new(options)
  end

  def start_network_game
    options = give_secondary_options
    server = TCPServer.open("0.0.0.0", 2000)
    puts "\nlocalhost:2000 fired up... Waiting for an opponent to join..."
    puts
    loop do
      stream = server.accept
      options[:stream] = stream
      options[:network] = true
      Game.new(options)
      stream.close
      exit
    end
  end

  def give_secondary_options
    puts "1 => Start a new game on normal mode"
    puts "2 => Start a new game on challenge mode"
    puts "3 => Start a new game on normal mode with a time limit"
    puts "4 => Start a new game on challenge mode with a time limit"
    puts "5 => Continue a saved game"
    puts "9 => Go to previous menu"
    puts "0 => Exit"
    print "\nPick an action: "

    case gets.chomp
    when "1"
      return {}
    when "2"
      return {challenge: true}
    when "3"
      print "Please enter the time limit in minutes: "
      limit = gets.chomp.to_i
      return {limit: limit}
    when "4"
      print "Please enter the time limit in minutes: "
      limit = gets.chomp.to_i
      return {challenge: true, limit: limit}
    when "5"
      return {saved: true}
    when "9"
      give_main_options
    when "0"
      exit
    else
      give_secondary_options
    end
  end
end