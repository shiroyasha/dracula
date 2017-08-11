require "spec_helper"

RSpec.describe Dracula do
  it "has a version number" do
    expect(Dracula::VERSION).not_to be nil
  end

  class Login < Dracula::Command
    def run
      "Log in"
    end
  end

  class TeamsInfo < Dracula::Command
    def run
      "Info for teams"
    end
  end

  class TeamsProjectsList < Dracula::Command
    def run
      "Listing team's projects"
    end
  end

  class Help < Dracula::Command
    def run
      "help"
    end
  end

  class CLI < Dracula::Router
    default "help"

    on "help" => Help
    on "login" => Login
    on "teams:info" => TeamsInfo
    on "teams:projects:list" => TeamsProjectsList

    on_not_found "help"
  end

  it "can route simple commands" do
    expect(CLI.run(["login"])).to eq("Log in")
  end

  it "can run namespaced commands" do
    expect(CLI.run(["teams:info"])).to eq("Info for teams")
  end

  it "can run deeply nested commands" do
    expect(CLI.run(["teams:projects:list"])).to eq("Listing team's projects")
  end

  it "can route to the default handler" do
    expect(CLI.run([])).to eq("help")
  end

  context "no route found" do
    it "can route to assigned handler" do
      expect(CLI.run(["lol"])).to eq("help")
    end
  end

end
