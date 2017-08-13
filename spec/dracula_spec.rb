require "spec_helper"

require_relative "example_cli"

RSpec.describe Dracula do
  it "has a version number" do
    expect(Dracula::VERSION).not_to be nil
  end

  describe "Help Screens" do
    describe "main help screen" do
      it "lists the commands and subtopics" do
        msg = [
          "Usage: cli COMMAND",
          "",
          "Help topics, type cli help TOPIC for more details:",
          "",
          "  login    Log in to the cli",
          "  teams    Manage teams",
          ""
        ].join("\n")

        expect { CLI.start(["help"]) }.to output(msg).to_stdout
      end
    end

    describe "command help" do
      it "shows the usage, flags, and long description" do
        msg = [
          "Usage: cli login",
          "",
          "Log in to the cli",
          "",
          "Flags:",
          "  -u, --username",
          "  -p, --password",
          "  -v, --verbose",
          "",
          "Examples:",
          "",
          "  $ cli login --username Peter --password Parker",
          "  Peter:Parker",
          ""
        ].join("\n")

        expect { CLI.start(["help login"]) }.to output(msg).to_stdout
      end
    end

    describe "subtopic help" do
      it "displays help for a subtopic" do
        msg = [
          "Usage: cli teams:<command>",
          "",
          "Manage teams",
          "",
          "  list     Show info for a team",
          "  projects Manage projects in a team",
          ""
        ].join("\n")

        expect { CLI.start(["help teams"]) }.to output(msg).to_stdout
      end
    end

    describe "subcommand help" do
      it "displays help for a subcommand" do
        msg = [
          "Usage: cli teams:info",
          "",
          "Show info for a team",
          ""
        ].join("\n")

        expect { CLI.start(["help teams:info"]) }.to output(msg).to_stdout
      end
    end
  end

  describe "Invoking commands" do
    it "can invoke simple commands" do
      msg = [
        "Peter:Parker"
      ].join("\n")

      expect { CLI.start(["login"]) }.to output(msg).to_stdout
    end

    it "can invoke nested commands"  do
      msg = [
        "X/Team A",
        "X/Team B",
        "X/Team C",
        ""
      ].join("\n")

      expect { CLI.start(["teams:list", "X"]) }.to output(msg).to_stdout
    end
  end
end
