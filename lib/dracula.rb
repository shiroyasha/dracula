require "dracula/version"
require "optparse"

module Dracula

  class Flag
    attr_reader :name
    attr_reader :default_value
    attr_reader :short_name
    attr_reader :type
    attr_reader :required

    def initialize(name, default_value, short_name, type, required)
      @name = name
      @default_value = default_value
      @short_name = short_name
      @type = type
    end
  end

  class Command
    def self.flags
      @flags ||= []
    end

    def self.flag(name, params= {})
      default_value = params[:default_value]
      short_name    = params[:short_name]
      type          = params[:type] || String
      required      = (params[:required] == true)

      flags << Flag.new(name, default_value, short_name, type, required)
    end

    def self.run(args)
      new([], parse_flags(args)).run
    end

    def self.parse_flags(args)
      parsed_flags = {}

      opt_parser = OptionParser.new do |opts|
        flags.each do |flag|
          short = "-#{flag.short_name}"
          long  = "--#{flag.name} VALUE"

          opts.on(short, long, flag.type) do |value|
            parsed_flags[flag.name] = value
          end
        end
      end

      opt_parser.parse!(args)

      parsed_flags
    end

    attr_reader :args
    attr_reader :flags

    def initialize(args, flags)
      @args = args
      @flags = flags
    end

  end

end
