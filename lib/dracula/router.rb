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

    def self.on(params)
      command = params.keys.first
      handler = params.values.first

      routes << Route.new(command, handler)
    end

    def self.run(args)
      command = args[0]
      params = args[1..-1]

      route = routes.find { |r| r.command == command }

      if route
        route.handler.run(params)
      else
        puts "lll"
      end
    end

  end
end
