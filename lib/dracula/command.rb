class Dracula
  class Command

    Desc = Struct.new(:name, :description)

    class Option < Struct.new(:name, :params)

      def alias_name
        params[:alias]
      end

      def banner
        if alias_name.empty?
          "--#{name}"
        else
          "-#{alias_name}, --#{name}"
        end
      end

    end

    attr_reader :method_name
    attr_reader :desc
    attr_reader :options
    attr_reader :long_desc

    def initialize(klass, method_name, desc, long_desc, options)
      @klass = klass
      @method_name = method_name
      @desc = desc
      @long_desc = long_desc
      @options = options || []
    end

    def name
      desc.name
    end

    def help
      msg = [
        "Usage: #{Dracula.program_name} #{@klass.namespace.name ? "#{@klass.namespace.name}:" : "" }#{desc.name}",
        "",
        "#{desc.description}",
        ""
      ]

      if options.size > 0
        msg << "Flags:"

        options.each { |option| msg << "  #{option.banner}" }

        msg << ""
      end

      unless long_desc.nil?
        msg << long_desc
      end

      puts msg.join("\n")
    end

    def run(params)
      @klass.new.public_send(method_name, *params)
    end

    # def self.flags
    #   @flags ||= []
    # end

    # def self.flag(name, params= {})
    #   flags << Flag.new(name, params)
    # end

    # def self.run(params)
    #   args = params.take_while { |p| p[0] != "-" }
    #   flags = params.drop_while { |p| p[0] != "-" }

    #   new(parse_flags(flags)).run(*args)
    # end

    # def self.parse_flags(args)
    #   parsed_flags = {}

    #   # set default values
    #   flags.each do |flag|
    #     if flag.has_default_value?
    #       parsed_flags[flag.name] = flag.default_value
    #     end
    #   end

    #   opt_parser = OptionParser.new do |opts|
    #     flags.each do |flag|
    #       if flag.boolean?
    #         short = "-#{flag.short_name}"
    #         long  = "--#{flag.name}"

    #         opts.on(short, long, flag.type) do
    #           parsed_flags[flag.name] = true
    #         end
    #       else
    #         short = "-#{flag.short_name}"
    #         long  = "--#{flag.name} VALUE"

    #         opts.on(short, long, flag.type) do |value|
    #           parsed_flags[flag.name] = value
    #         end
    #       end
    #     end
    #   end

    #   opt_parser.parse!(args)

    #   parsed_flags
    # end

    # attr_reader :flags

    # def initialize(flags)
    #   @flags = flags
    # end
  end
end
