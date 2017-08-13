require "dracula/version"
require "optparse"

class Dracula
  require "dracula/command"
  # require "dracula/flag"
  # require "dracula/router"

  Subcommand = Struct.new(:name, :description, :klass)

  def self.start(args)
    if args.empty?
      help
    else
      command = args.shift
      params = args

      dispatch(command, params)
    end
  end

  def self.help
    puts "Showing help"
  end

  def self.dispatch(command_name, params)
    if command_name.include?(":")
      topic, command_name = command_name.split(":", 2)

      subcommand = subcommands.find { |sc| sc.name == topic }

      if subcommand
        subcommand.klass.dispatch(command_name, params)
      else
        puts "Command '#{topic}:#{command_name} not found"
        help
      end
    else
      command = commands.find { |c| c.name.to_s == command_name }

      if command
        self.new.public_send(command.name, *params)
      else
        puts "Command '#{command_name}' not found"
        help
      end
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

  attr_reader :options

  def initialize
    @options = {}
  end

end
