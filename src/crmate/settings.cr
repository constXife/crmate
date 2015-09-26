module Crmate
  # Settings class
  #
  # @host       [String]  host to connect
  # @port       [Int32]   port to connect
  # @unixsocket [String]  unixsocket to connect
  # @wait       [Bool]
  # @force      [Bool]
  # @verbose    [Bool]
  class Settings
    property host, port, unixsocket, wait, force, verbose

    # Initialize method
    #
    # @params (see class doc)
    # @return [nil]
    def initialize(@host = "", @port = 52698, @unixsocket = "~/.rmate.socket",
      @wait = false, @force = false, @verbose = false)
    end
  end
end
