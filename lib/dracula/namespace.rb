class Dracula
  class Namespace

    attr_accessor :name
    attr_accessor :description
    attr_accessor :commands
    attr_accessor :subcommands

    def initialize(klass)
      @klass = klass
      @commands = []
      @subcommands = []
    end

    def dispatch(route, params, action = :run)
      case route.size
      when 0 then
        action == :run ? run(params) : help
      when 1 then
        handler = commands.find { |c| c.name == route[0] } || subcommands.find { |c| c.name == route[0] }

        if handler
          action == :run ? handler.run(params) : handler.help
        else
          help
        end
      else
        handler = subcommands.find { |c| c.name == route[0] }

        if handler
          handler.dispatch(route[1..-1], params, action)
        else
          help
        end
      end
    end

    def run(params)
      help
    end

    def help
      prefix = name ? "#{name}:" : ""

      puts "Usage: #{Dracula.program_name} #{prefix}<command>"
      puts ""
      puts (description || "Help topics, type #{Dracula.program_name} help TOPIC for more details:")
      puts ""

      command_list = []

      commands.each do |cmd|
        command_list << ["#{prefix}#{cmd.desc.name}", cmd.desc.description]
      end

      subcommands.each do |sub_cmd|
        command_list << ["#{prefix}#{sub_cmd.name}", sub_cmd.description]
      end

      Dracula::UI.print_table(command_list, :indent => 2)
    end

    def add_command(command)
      @commands << command
    end

    def add_subcommand(subcommand)
      @subcommands << subcommand
    end

  end
end
