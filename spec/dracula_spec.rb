require "spec_helper"

RSpec.describe Dracula do
  it "has a version number" do
    expect(Dracula::VERSION).not_to be nil
  end

  class Login < Dracula::Command
    flag :username, :short => "u", :required => true
    flag :password, :short => "p", :required => true
    flag :verbose,  :short => "v", :type => :boolean

    def run
      if flags[:verbose]
        "flag username: #{flags[:username]}; flag password: #{flags[:password]}"
      else
        "#{flags[:username]}:#{flags[:password]}"
      end
    end
  end

  it "parses command line flags" do
    result = Login.run(["--username", "Peter", "--password", "Parker"])

    expect(result).to eq("Peter:Parker")
  end

  it "parses short command line flags" do
    result = Login.run(["-u", "Peter", "--password", "Parker"])

    expect(result).to eq("Peter:Parker")
  end

  it "parses boolean flags" do
    result = Login.run(["-u", "Peter", "--password", "Parker", "-v"])

    expect(result).to eq("flag username: Peter; flag password: Parker")

    result = Login.run(["-u", "Peter", "--verbose", "--password", "Parker"])

    expect(result).to eq("flag username: Peter; flag password: Parker")
  end

end
