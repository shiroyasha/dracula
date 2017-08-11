module Dracula
  class Flag
    attr_reader :name
    attr_reader :short_name
    attr_reader :type

    def initialize(name, params)
      @name = name
      @params = params

      @short_name = params.fetch(:short)
      @type = params.fetch(:type, :string)
    end

    def boolean?
      type == :boolean
    end

    def has_default_value?
      @params.key?(:default_value) || boolean?
    end

    def default_value
      if type == :boolean
        @params.key?(:default_value) || false
      else
        @default_value
      end
    end
  end
end
