class CLI < Dracula
  option :username, :required => true
  option :password, :required => true
  option :verbose, :type => :boolean
  desc "login", "Log in to the cli"
  long_desc <<-LONGDESC
    Login in to the CLI

    Examples:

      $ cli login --username Peter --password Parker
      Peter:Parker
  LONGDESC
  def login
    if options[:verbose]
      puts "Starting login sequence"
      puts "#{option[:username]} #{option[:password]}"
      puts "Done"
    else
      puts "#{option[:username]}:#{option[:password]}"
    end
  end

  class Teams < Dracula

    desc "list", "List teams in an organization"
    def list(org)
      puts "Team A"
      puts "Team B"
      puts "Team C"
    end

    desc "info", "Show info for a team"
    def info(team)
      "Team info for #{team}"
    end

    class Projects < Dracula

      desc "add", "Add a project to the team"
      def add(team, project)
        "Adding #{project} to the #{team}"
      end

      desc "list", "List projects in a team"
      def list(team)
        puts "Project A"
        puts "Project B"
        puts "Project C"
      end

    end

    register "projects", "Manage projects in a team", Projects

  end

  register "teams", "Manage teams", Teams
end
