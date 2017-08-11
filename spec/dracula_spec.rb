require "spec_helper"

RSpec.describe Dracula do
  it "has a version number" do
    expect(Dracula::VERSION).not_to be nil
  end

  class Login < Dracula::Command
    flag :username, :short => "u", :required => true
    flag :password, :short => "p", :required => true

    def run
      "#{flags[:username]}:#{flags[:password]}"
    end
  end

  it "parser command line flags" do
    result = Login.run(["--username", "Peter", "--password", "Parker"])

    expect(result).to eq("Peter:Parker")
  end

  it "parser short command line flags" do
    result = Login.run(["-u", "Peter", "--password", "Parker"])

    expect(result).to eq("Peter:Parker")
  end

end
