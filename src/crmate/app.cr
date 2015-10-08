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
        parser.banner = "Usage: rmate [arguments]"
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
  end
end
