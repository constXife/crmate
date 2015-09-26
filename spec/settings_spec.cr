require "./spec_helper"

describe Crmate::Settings do
  describe "properly gets settings" do
    it "#host" do
      host = "google.com"
      settings = Crmate::Settings.new(host: host)
      settings.host.should eq(host)
    end

    it "#port" do
      port = 123
      settings = Crmate::Settings.new(port: port)
      settings.port.should eq(port)
    end

    it "#unixsocket" do
      unixsocket = "/dev/socket"
      settings = Crmate::Settings.new(unixsocket: unixsocket)
      settings.unixsocket.should eq(unixsocket)
    end

    it "#wait" do
      wait = true
      settings = Crmate::Settings.new(wait: wait)
      settings.wait.should eq(wait)
    end

    it "#force" do
      force = true
      settings = Crmate::Settings.new(force: force)
      settings.force.should eq(force)
    end

    it "#verbose" do
      verbose = true
      settings = Crmate::Settings.new(verbose: verbose)
      settings.verbose.should eq(verbose)
    end

    

    # it "#lines" do
    #   @settings.lines.should eq(@settings_hash[:lines])
    # end
    #
    # it "#names" do
    #   @settings.names.should eq(@settings_hash[:names])
    # end
    #
    # it "#types" do
    #   @settings.types.should eq(@settings_hash[:types])
    # end
  end
end
