require "dracula/version"
require "optparse"

class Dracula
  # require "dracula/command"
  # require "dracula/flag"
  # require "dracula/router"

  def self.start(args)
  end

  def self.option(name, params = {})
  end

  def self.long_desc(description)
  end

  def self.desc(command, description)
  end

  def self.register(name, description, klass)
  end

  private_class_method def self.method_added(method_name)
    puts "#{method_name}"
  end

end
