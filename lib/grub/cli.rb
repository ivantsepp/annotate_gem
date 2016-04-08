require "grub/options"

module Grub
  class CLI
    def run(args)
      options = Options.new.parse!(args)
      if args.empty?
        run_for_gemfile(options)
      else
        run_for_gem(args.pop, options)
      end
    end

    def run_for_gemfile(options = {})
      Bundler.configure
      gemfile = Gemfile.new(Bundler.default_gemfile, options)
      gemfile.parse
      unless gemfile.gem_lines.empty?
        SpecFinder.find_specs_for(gemfile.gem_lines)
        gemfile.write_comments
      end
    end

    def run_for_gem(gem_name, options = {})
      gem_line = GemLine.new(name: gem_name, options: options)
      SpecFinder.find_specs_for(gem_line)
      info = gem_line.info
      info = "No information to show" if info.strip.empty?
      puts info
    end
  end
end
