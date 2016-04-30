require "annotate_gem/options"

module AnnotateGem
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
        SpecFinder.find_specs_for(gemfile.gem_lines, &self.method(:print_progress))
        gemfile.write_comments
      end
    end

    def run_for_gem(gem_name, options = {})
      gem_line = GemLine.new(name: gem_name, options: options)
      SpecFinder.find_specs_for(gem_line, &self.method(:print_progress))

      info = gem_line.info
      info = "No information to show" if info.strip.empty?
      puts info
    end

    private

    def print_progress(processing, total)
      print "Fetching gem metadata..." if processing.zero?
      print "."
      print "\n" if processing == total
    end
  end
end
