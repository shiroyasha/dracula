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

  class CLI < Dracula::Router
    on "login" => Login
    on "teams:info" => TeamsInfo
    on "teams:projects:list" => TeamsProjectsList
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

end
