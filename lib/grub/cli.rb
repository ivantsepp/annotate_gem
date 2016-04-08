module Grub
  class CLI
    def run(*args)
      gemfile = Gemfile.new
      gemfile.parse
      unless gemfile.gem_lines.empty?
        SpecFinder.find_specs_for(gemfile.gem_lines)
        gemfile.write_comments
      end
    end
  end
end
