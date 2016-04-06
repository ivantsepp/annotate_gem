module Grub
  class CLI
    def run(*args)
      Bundler.configure
      gemfile = Gemfile.new
      gemfile.parse
      unless gemfile.gem_lines.empty?
        SpecFinder.new(gemfile.gem_lines).find_specs
        gemfile.write_comments
      end
    end
  end
end
