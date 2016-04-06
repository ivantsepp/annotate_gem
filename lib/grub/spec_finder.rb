module Grub
  class SpecFinder

    attr_reader :gem_lines

    def initialize(gem_lines)
      @gem_lines = gem_lines
    end

    def find_specs
      gem_lines.each do |line|
        matching_specs = Gem::Dependency.new(line.name).matching_specs
        line.spec = matching_specs.first if matching_specs.any?
      end

      gems_to_fetch = gem_lines.select { |gem_line| gem_line.spec.nil? }

      if gems_to_fetch.any?
        fetcher = Bundler::Fetcher.new(Gem.sources.first.uri)
        versions, _ = fetcher.send(:fetch_dependency_remote_specs, gems_to_fetch.collect(&:name))
        gems_to_fetch.each do |gem_line|
          print "."
          version = versions.find{ |v| v.first == gem_line.name }[1]
          spec = fetcher.fetch_spec([gem_line.name, version])
          gem_line.spec = spec
        end
        print "\n"
      end
    end

  end
end
