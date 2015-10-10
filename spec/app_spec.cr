require "./spec_helper"

describe Crmate::App do
  describe "properly parse CLI" do
    pipe = StringIO.new
    crmate = Crmate::App.new(io: pipe)

    it "#host" do
      host = "google.com"
      crmate.parse_cli(args: ["--host=#{host}"])
      crmate.settings.host.should eq(host)
    end

    it "#unixsocket" do
      unixsocket = "~/.test-rmate.socket"
      crmate.parse_cli(args: ["--unixsocket=#{unixsocket}"])
      crmate.settings.unixsocket.should eq(unixsocket)
    end

    it "#port" do
      port = 69
      crmate.parse_cli(args: ["--port=#{port}"])
      crmate.settings.port.should eq(port)
    end

    it "#wait" do
      wait = true
      crmate.parse_cli(args: ["--wait"])
      crmate.settings.wait.should eq(wait)
    end

    it "#force" do
      force = true
      crmate.parse_cli(args: ["--force"])
      crmate.settings.force.should eq(force)
    end

    it "#verbose" do
      verbose = true
      crmate.parse_cli(args: ["--verbose"])
      crmate.settings.verbose.should eq(verbose)
    end

    it "#help" do
      crmate.parse_cli(args: ["--help"])
      pipe.to_s.lines[0].should eq("Usage: crmate [arguments]\n")
      pipe.clear
    end

    it "#version" do
      crmate.parse_cli(args: ["--version"])
      pipe.to_s.lines[0].should eq("#{Crmate::VERSION}\n")
      pipe.clear
    end
  end
end
