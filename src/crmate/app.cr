module Crmate
  # Settings class
  #
  # @io [IO] IO stream to output.
  class App
    getter settings

    # Initialize method
    #
    # @params (see class doc)
    def initialize(@io = STDOUT)
      @settings = Settings.new
    end

    # Parse CLI arguments
    #
    # @args Array<String> arguments
    def parse_cli(args = [] of String)
      OptionParser.parse(args) do |parser|
        parser.banner = "Usage: crmate [arguments]"
        parser.on("--host=HOST", "Host") do |host|
          settings.host = host
        end
        parser.on("--unixsocket=UNIXSOCKET", "Socket path") do |unixsocket|
          settings.unixsocket = unixsocket
        end
        parser.on("-p", "--port=PORT", "Port") do |port|
          settings.port = port
        end
        parser.on("-w", "--wait", "Wait") do
          settings.wait = true
        end
        parser.on("-f", "--force", "Force") do
          settings.force = true
        end
        parser.on("--verbose", "Verbose") do
          settings.verbose = true
        end
        parser.on("-v", "--version", "Show version") { output Crmate::VERSION }
        parser.on("-h", "--help", "Show this help") { output parser }
      end
    end

    # Print messages into IO stream
    #
    # @message [String] message to print
    def output(message = "")
      @io.puts message
    end

    # Print verbose messages
    #
    # @message [String] message to print
    def verbose(message = "")
      output(message) if settings.verbose
    end

    def connect_and_handle_cmds(cmds = [] of String)
      socket = nil
      unixsocketpath = settings.unixsocket
      if unixsocketpath.nil? || !File.exist?(unixsocketpath)
        verbose("Using TCP Socket to connect: #{host}:#{port}")
        begin
          socket = TCPSocket.new(settings.host, settings.port)
        rescue e : Exception
          fail "Error connecting to #{host}:#{port}: #{e.message}"
        end
      else
        verbose("Using unix sockets to connect: #{unixsocketpath}")
        socket = UNIXSocket.new(unixsocketpath)
      end

      server_info = socket.read_line.chomp
      verbose("Connect: #{server_info}")

      cmds.each {|cmd| cmd.send(socket)}

      socket.puts "."
      while !socket.eof?
        handle_cmd(socket)
      end
      socket.close
      verbose("Done")
    end

    def handle_cmd(socket)
      cmd = socket.read_line.chomp

      variables = {} of KeyType => ValueType
      data = ""

      while line = socket.read_line.chomp
        break if line.empty?

        name, value = line.split(": ", 2)
        variables[name] = value
        data << socket.read(value.to_i) if name == "data"
      end
      variables.delete("data")

      case cmd
      when "save"
        handle_save(socket, variables, data)
      when "close"
        handle_close(socket, variables, data)
      else
        fail "Received unknown command #{cmd}, exiting."
      end
    end

    def handle_save(socket, variables, data)
      path = variables["token"]
      if File.writeable?(path) || !File.exist?(path)
        verbose("Saving #{path}")
        begin
          backup_path = "#{path}~"
          backup_path = "#{backup_path}~" while File.exist?(backup_path)
          FileUtils.cp(path, backup_path, preserve: true) if File.exist?(path)
          open(path, 'wb') {|file| file << data}
          File.unlink(backup_path) if File.exist?(backup_path)
        rescue
          verbose("Skipping save, file not writeable")
        end
      end
    end

    def handle_close(socket, variables, data)
      path = variables["token"]
      verbose("Closed #{path}")
    end
  end
end
