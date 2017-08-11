module Dracula
  class Router

    class Route
      attr_reader :command
      attr_reader :handler

      def initialize(command, handler)
        @command = command
        @handler = handler
      end
    end

    def self.routes
      @routes ||= []
    end

    def self.default(command)
      @default = command
    end

    def self.on_not_found(command)
      @on_not_found = command
    end

    def self.on(params)
      command = params.keys.first
      handler = params.values.first

      routes << Route.new(command, handler)
    end

    def self.run(args)
      command = ""
      params = []

      if args.size == 0
        command = @default
      else
        command = args[0]
        params = args[1..-1]
      end

      route = routes.find { |r| r.command == command }

      if route
        route.handler.run(params)
      else
        route = routes.find { |r| r.command == @on_not_found }

        if route
          route.handler.run(params)
        else
          puts "No such command"
        end
      end
    end

  end
end
