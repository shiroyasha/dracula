require "dracula/version"
require "optparse"

class Dracula
  require "dracula/command"
  # require "dracula/flag"
  # require "dracula/router"

  Subcommand = Struct.new(:name, :description, :klass)

  def self.start(args)
    p commands

    subcommands.each do |sc|
      p sc.name
      p sc.klass.commands
    end
  end

  def self.option(name, params = {})
    @options ||= []
    @options << Command::Option.new(name, params)
  end

  def self.long_desc(description)
    @long_desc = description
  end

  def self.desc(name, description)
    @desc = Command::Desc.new(name, description)
  end

  def self.register(name, description, klass)
    subcommands << Subcommand.new(name, description, klass)
  end

  def self.commands
    @commands ||= []
    @commands
  end

  def self.subcommands
    @subcommands ||= []
    @subcommands
  end

  private_class_method def self.method_added(method_name)
    commands << Command.new(method_name, @desc, @long_desc, @options)

    @desc = nil
    @long_desc = nil
    @options = nil
  end

end
