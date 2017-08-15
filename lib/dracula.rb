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

      if command == "help"
        help(params)
      else
        dispatch(command, params)
      end
    end
  end

  def self.help(params = [])
    if params.empty?
      topic_help
    else
      command_name = params.first

      if command_name.include?(":")
        topic, command_name = command_name.split(":", 2)

        subcommand = subcommands.find { |sc| sc.name == topic }

        if subcommand
          subcommand.klass.help(command_name)
        else
          puts "Command '#{topic}:#{command_name} not found"
          help
        end
      else
        command = commands.find { |c| c.name.to_s == command_name }

        if command
          command_help(command)
        else
          subcommand = subcommands.find { |sc| sc.name == command_name }

          if subcommand
            subcommand.klass.help
          else
            puts "Command '#{command_name}' not found"
            help
          end
        end
      end
    end
  end

  def self.command_help(command)
    msg = [
      "Usage: cli #{command.desc.name}",
      "",
      "#{command.desc.description}",
      ""
    ]

    if command.options.size > 0
      msg << "Flags:"

      command.options.each do |option|
        if option.alias.empty?
          msg << "  --#{option.name}"
        else
          msg << "  -#{option.alias}, --#{option.name}"
        end
      end

      msg << ""
    end

    msg << command.long_desc

    puts msg.join("\n")
  end

  def self.topic_help
    message = [
      "Usage: cli COMMAND",
      "",
      "Help topics, type cli help TOPIC for more details:",
      ""
    ]

    commands.each do |cmd|
      message << "  #{cmd.desc.name}  #{cmd.desc.description}"
    end

    subcommands.each do |sub_cmd|
      message << "  #{sub_cmd.name}  #{sub_cmd.description}"
    end

    message << ""

    puts message.join("\n")
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
        self.new.public_send(command.method_name, *params)
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
