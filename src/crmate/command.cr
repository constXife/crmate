module Crmate
  class Command
    def initialize(name)
      @command    = name
      @variables  = {} of KeyType => ValueType
      @data       = nil
      @size       = nil
    end

    def []=(name, value)
    end

    def read_file(path)
      @size = File.size(path)
      @data = File.open(path, "rb") {|io| io.read(@size)}
    end

    def read_stdin
      @data = STDIN.read
      @size = @data.size
    end

    def send(socket)
      socket.puts @command
      @variables.each_pair do |name, value|
        value = 'yes' if value === true
        socket.puts "#{name}: #{value}"
      end

      if @data
        socket.puts "data: #{size}"
        socket.puts @data
      end
      socket.puts
  end
end
