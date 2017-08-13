require "spec_helper"

require_relative "example_cli"

RSpec.describe Dracula do
  it "has a version number" do
    expect(Dracula::VERSION).not_to be nil
  end
end
