module Dracula
  class Command
    def self.flags
      @flags ||= []
    end

    def self.flag(name, params= {})
      flags << Flag.new(name, params)
    end

    def self.run(args)
      new([], parse_flags(args)).run
    end

    def self.parse_flags(args)
      parsed_flags = {}

      # set default values
      flags.each do |flag|
        if flag.has_default_value?
          parsed_flags[flag.name] = flag.default_value
        end
      end

      opt_parser = OptionParser.new do |opts|
        flags.each do |flag|
          if flag.boolean?
            short = "-#{flag.short_name}"
            long  = "--#{flag.name}"

            opts.on(short, long, flag.type) do
              parsed_flags[flag.name] = true
            end
          else
            short = "-#{flag.short_name}"
            long  = "--#{flag.name} VALUE"

            opts.on(short, long, flag.type) do |value|
              parsed_flags[flag.name] = value
            end
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
