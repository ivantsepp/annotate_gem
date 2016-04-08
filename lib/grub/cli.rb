require "grub/options"

module Grub
  class CLI
    def run(args)
      options = Options.new.parse!(args)
      if args.empty?
        run_for_gemfile
      else
        run_for_gem(args.pop)
      end
    end

    def run_for_gemfile
      Bundler.configure
      gemfile = Gemfile.new
      gemfile.parse
      unless gemfile.gem_lines.empty?
        SpecFinder.find_specs_for(gemfile.gem_lines)
        gemfile.write_comments
      end
    end

    def run_for_gem(gem_name)
      gem_line = GemLine.new(name: gem_name)
      SpecFinder.find_specs_for(gem_line)
      puts gem_line.info
    end
  end
end
