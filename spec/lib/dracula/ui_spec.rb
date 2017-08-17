require "spec_helper"

describe Dracula::UI do

  describe ".print_table" do
    it "prints a table" do
      input = [
        ["A", "B"],
        ["something long", "bbb"],
        ["short", "ccc"]
      ]

      out = [
        "  A               B",
        "  something long  bbb",
        "  short           ccc",
        ""
      ].join("\n")

      expect { Dracula::UI.print_table(input, :indent => 2) }.to output(out).to_stdout
    end
  end

end
